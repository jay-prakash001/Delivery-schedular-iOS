import SwiftUI
import Combine
import MapKit
import CoreLocation

// MARK: - Location Manager
@MainActor
final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published var cameraPosition: MapCameraPosition = .automatic
    @Published var selectedCoordinate: CLLocationCoordinate2D?
    @Published var address: String = "Select location"
    @Published var isFetching: Bool = false
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // Request permission + current location
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
        
        if manager.authorizationStatus == .authorizedWhenInUse ||
            manager.authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
    
    // Permission status changed
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse ||
            manager.authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
    
    // Get current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        let region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
        
        cameraPosition = .region(region)
        selectedCoordinate = location.coordinate
        
        updateAddress(for: location.coordinate)
        
        manager.stopUpdatingLocation()
    }
    
    // Reverse geocode
    func updateAddress(for coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        
        isFetching = true
        
        Task {
            do {
                let placemarks = try await geocoder.reverseGeocodeLocation(location)
                
                if let place = placemarks.first {
                    address = [
                        place.name,
                        place.subLocality,
                        place.locality
                    ]
                        .compactMap { $0 }
                        .joined(separator: ", ")
                }
                
            } catch {
                address = "Location not recognized"
            }
            
            isFetching = false
        }
    }
}

// MARK: - Main View
struct SignUpMapView: View {
    
    @StateObject private var locationManager = LocationManager()
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            
            headerView
            
            ZStack {
                
                Map(position: $locationManager.cameraPosition) {
                    if let coord = locationManager.selectedCoordinate {
                        Marker("Delivery Point", coordinate: coord)
                            .tint(.green)
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity)

                .onMapCameraChange(frequency: .onEnd) { context in
                    let center = context.region.center
                    locationManager.selectedCoordinate = center
                    locationManager.updateAddress(for: center)
                }
                
                // Center pin
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 42))
                    .foregroundColor(.red)
                    .shadow(radius: 5)
                    .offset(y: -20)
            }
            .ignoresSafeArea(edges: .top)
            
            locationDetailsCard
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            locationManager.requestPermission()
        }
    }
}

// MARK: - UI Views
extension SignUpMapView {
    
    private var headerView: some View {
        HStack {
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3.bold())
                    .foregroundColor(.black)
                    .padding(10)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 2)
            }
            
            Spacer()
            
            Text("Set Delivery Location")
                .font(.headline)
                .foregroundColor(.black)
            
            Spacer()
            
            Circle()
                .fill(.clear)
                .frame(width: 40, height: 40)
        }
        .padding()
        .background(Color.white)
    }
    
    private var locationDetailsCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            
            HStack(alignment: .top) {
                
                Image(systemName: "location.fill")
                    .foregroundColor(.green)
                    .padding(.top, 3)
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    Text("Selected Address")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .fontWeight(.semibold)
                    
                    if locationManager.isFetching {
                        ProgressView()
                            .scaleEffect(0.9)
                    } else {
                        Text(locationManager.address)
                            .font(.body)
                            .fontWeight(.medium)
                    }
                }
                
                Spacer()
                
                Button {
                    locationManager.requestPermission()
                } label: {
                    Image(systemName: "scope")
                        .font(.title2)
                        .foregroundColor(.green)
                }
            }
            
            Button {
                confirmLocation()
            } label: {
                Text("Confirm & Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(24)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: .black.opacity(0.12), radius: 8, y: -4)
    }
}

// MARK: - Actions
extension SignUpMapView {
    
    private func confirmLocation() {
        withAnimation(.spring()) {
            authVM.isNewCustomer = false
            authVM.isLoggedIn = true
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        SignUpMapView()
            .environmentObject(AuthViewModel())
    }
}
