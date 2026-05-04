


import SwiftUI
import GoogleMaps
import CoreLocation
import Combine
import Contacts

// MARK: - Google Maps SwiftUI Wrapper

struct GoogleMapsView: UIViewRepresentable {
    @ObservedObject var locationManager: LocationManager
    
    func makeUIView(context: Context) -> GMSMapView {
        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 15)
        
        let mapView = GMSMapView(options: options)
        mapView.delegate = context.coordinator
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = false
        
        return mapView
    }
    
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
            guard let coord = locationManager.selectedCoordinate else { return }
            
            // Check if this update is coming from the user dragging the map
            if context.coordinator.isInternalUpdate {
                context.coordinator.isInternalUpdate = false
                return
            }
            
            // FIX: Use uiView.camera.zoom instead of hardcoded 15
            // This keeps the user's preferred zoom level when the button is pressed
            let camera = GMSCameraPosition.camera(withTarget: coord, zoom: uiView.camera.zoom)
            uiView.animate(to: camera)
        }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapsView
        var isInternalUpdate = false
        
        init(_ parent: GoogleMapsView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            let newCenter = position.target
            
            if let old = parent.locationManager.selectedCoordinate {
                let latDiff = abs(old.latitude - newCenter.latitude)
                let lonDiff = abs(old.longitude - newCenter.longitude)
                // If the map hasn't actually moved significantly, do nothing
                guard latDiff > 0.00001 || lonDiff > 0.00001 else { return }
            }
            
            // Mark this as an internal update so updateUIView ignores it
            isInternalUpdate = true
            
            parent.locationManager.selectedCoordinate = newCenter
            parent.locationManager.updateAddress(for: newCenter)
        }
    }
}

// MARK: - Main UI View
struct SignUpMapView: View {
    @StateObject private var locationManager = LocationManager()
    @EnvironmentObject var authViewModel: AuthViewModel // Add this to access your VM
    var body: some View {
        VStack(spacing: 0) {
            // Address Display Header
            
            ZStack(alignment: .center) { // 1. Set default alignment to Center
                
                // MARK: - Layer 1: Background Map
                GoogleMapsView(locationManager: locationManager)
                    .edgesIgnoringSafeArea(.all)
                
                // MARK: - Layer 2: Static Center Pin
                // Since ZStack is .center, this stays perfectly in the middle
                VStack {
                    Image("location_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    
                    // This spacer ensures the 'pointy' part of your logo is at the center
                    Spacer().frame(height: 40)
                }
                
                // MARK: - Layer 3: Floating Action Button
                VStack {
                    Spacer() // 2. Pushes the HStack to the bottom
                    
                    HStack {
                        Spacer() // 3. Pushes the Button to the right
                        
                        Button {
                            locationManager.requestPermission()
                        } label: {
                            Image(systemName: "arrow.clockwise") // "refresh.fill" works too!
                                .font(.title2).bold()
                                .foregroundColor(.green)
                                .frame(width: 56, height: 56)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20) // Adjust for Home Indicator/Safe Area
                    }
                }
            }
            VStack(alignment: .leading, spacing: 5) {
                
                if let error = authViewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                Text("SELECTED ADDRESS")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                ZStack(alignment: .leading) {
                    if locationManager.isFetching {
                        HStack(spacing: 10) {
                            ProgressView().scaleEffect(0.8)
                            Text("Locating...")
                                .font(.body)
                                .italic()
                        }
                        .transition(.opacity) // Fade in/out only
                    } else {
                        Text(locationManager.address)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .transition(.opacity) // Fade in/out only
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemBackground))
            // Apply easeInOut only to the address change to handle height expansion
            .animation(.easeInOut(duration: 0.1), value: locationManager.isFetching)
            .animation(.easeInOut(duration: 0.1), value: locationManager.address)
            
            // Bottom Button
            Button(action: {
//                locationManager.requestPermission()
                authViewModel.registerNewCustomer()
                
            }) {
                HStack {
                    if authViewModel.isLoggedIn{
                        
                        Image(systemName: "checkmark.circle.fill")
                        Text("Done")
                            .fontWeight(.semibold)
                    }else{
                        ProgressView().frame(width: 20)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.appGreen)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding()
        }
        // Observe coordinate via an Equatable String key
        .onChange(of: coordinateKey(locationManager.selectedCoordinate)) { _ in
            if let coord = locationManager.selectedCoordinate {
                authViewModel.lat = String(coord.latitude)
                authViewModel.lng = String(coord.longitude)
            }
        }
        .onChange(of: locationManager.address) { newAddress in
            authViewModel.address = newAddress
        }
    }
    
    // Build a stable key that changes when the coordinate meaningfully changes
    private func coordinateKey(_ coord: CLLocationCoordinate2D?) -> String {
        guard let c = coord else { return "nil" }
        // Round to 6 decimals (~0.11m) to avoid tiny jitter causing updates
        let lat = String(format: "%.6f", c.latitude)
        let lng = String(format: "%.6f", c.longitude)
        return lat + "," + lng
    }
}

#Preview {
    SignUpMapView()
}

