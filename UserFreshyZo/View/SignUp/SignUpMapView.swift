


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
//    func updateUIView(_ uiView: GMSMapView, context: Context) {
//        guard let coord = locationManager.selectedCoordinate else { return }
//        
//        // Check if this update is coming from the user dragging the map
//        // If it is, we skip the camera update to prevent the flicker
//        if context.coordinator.isInternalUpdate {
//            context.coordinator.isInternalUpdate = false
//            return
//        }
//        
//        // This part only runs when the "Use My Current Location" button is pressed
//        let camera = GMSCameraPosition.camera(withTarget: coord, zoom: 15)
//        uiView.animate(to: camera)
//    }
    
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
    
    var body: some View {
        VStack(spacing: 0) {
            // Address Display Header
            
            // Map Section
            ZStack {
                GoogleMapsView(locationManager: locationManager)
                    .edgesIgnoringSafeArea(.all)
                
                // Static Center Pin
                VStack {
                    Image("location_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20) // adjust size like an icon//                        .overlay(
//
                    Spacer().frame(height: 35)
                }
            }
            
            
            VStack(alignment: .leading, spacing: 5) {
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
                locationManager.requestPermission()
            }) {
                HStack {
                    Image(systemName: "location.fill")
                    Text("Use My Current Location")
                        .fontWeight(.semibold)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.appGreen)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding()
        }
    }
}

#Preview {
    SignUpMapView()
}
