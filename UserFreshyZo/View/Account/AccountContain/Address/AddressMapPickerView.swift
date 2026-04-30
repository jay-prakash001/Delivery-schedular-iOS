//
//  AddressMapPickerView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 06/04/26.
//

import SwiftUI
import MapKit
import CoreLocation
import Combine

// MARK: - AddressMapPickerView

struct AddressMapPickerView: View {

    @ObservedObject var vm: AddressViewModel
    @Environment(\.dismiss) private var dismiss

    @StateObject private var locationManager = MapLocationManager()

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 21.2514, longitude: 81.6296),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var centerCoord = CLLocationCoordinate2D(
        latitude: 21.2514, longitude: 81.6296
    )
    @State private var resolvedAddress: String = "Detecting location..."
    @State private var isResolving:     Bool   = false

    // ✅ Track whether user tapped "Use current location" while GPS was still loading
    @State private var pendingJumpToCurrentLocation = false
    @State private var isWaitingForGPS = false

    // Search
    @State private var searchText:    String      = ""
    @State private var searchResults: [MKMapItem] = []
    @FocusState private var searchFocused: Bool

    // Bottom sheet mode
    @State private var showDeliveryOptions = true
    @State private var showConfirmSheet    = false

    // Single geocoder instance
    private let geocoder = CLGeocoder()

    var body: some View {
        ZStack {

            // ── Map ───────────────────────────────────────────────────
            MapView(region: $region, onRegionChanged: { coord in
                // Only geocode on user drag (not on initial GPS jump)
                if !isWaitingForGPS {
                    centerCoord = coord
                    resolvedAddress = "Detecting location..."
                    reverseGeocode(coord)
                }
            })
            .ignoresSafeArea()

            // ── Fixed centre pin + tooltip ────────────────────────────
            VStack(spacing: 0) {
                Text("Place pin on the exact location")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.78))
                    .cornerRadius(20)
                    .padding(.bottom, 6)

                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 38))
                    .foregroundColor(.black)
                    .shadow(radius: 4)

                Ellipse()
                    .fill(Color.black.opacity(0.18))
                    .frame(width: 12, height: 4)
            }
            .offset(y: -44)

            // ── Top bar ───────────────────────────────────────────────
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Button { dismiss() } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                            .frame(width: 38, height: 38)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.12), radius: 4, y: 2)
                    }

                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                        TextField("Search by area, name, street...", text: $searchText)
                            .font(.system(size: 14))
                            .focused($searchFocused)
                            .submitLabel(.search)
                            .onSubmit { performSearch() }
                            .onChange(of: searchText) { _, val in
                                if val.isEmpty { searchResults = [] }
                                else { performSearch() }
                            }
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                                searchResults = []
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
                }
                .padding(.horizontal, 16)
                .padding(.top, 54)
                .padding(.bottom, 8)

                // Search results dropdown
                if !searchResults.isEmpty && searchFocused {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(searchResults, id: \.self) { item in
                                Button { selectSearchResult(item) } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: "mappin")
                                            .foregroundColor(.red)
                                            .frame(width: 20)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(item.name ?? "")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.primary)
                                            if let addr = item.placemark.title {
                                                Text(addr)
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.secondary)
                                                    .lineLimit(1)
                                            }
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                }
                                Divider().padding(.leading, 48)
                            }
                        }
                    }
                    .frame(maxHeight: 220)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 6, y: 3)
                    .padding(.horizontal, 16)
                }

                Spacer()
            }

            // ── GPS loading spinner (shown while waiting for location) ─
            if isWaitingForGPS {
                VStack(spacing: 12) {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(1.2)
                        .tint(.white)
                    Text("Getting your location...")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 28)
                .padding(.vertical, 18)
                .background(Color.black.opacity(0.65))
                .cornerRadius(16)
            }

            // ── "Use my current location" floating button ─────────────
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button { handleUseCurrentLocation() } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "location.circle.fill")
                                .font(.system(size: 15))
                                .foregroundColor(.blue)
                            Text("Use my current location")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.blue)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.12), radius: 4, y: 2)
                    }
                    Spacer()
                }
                .padding(.bottom, showDeliveryOptions ? 295 : 210)
            }

            // ── Bottom Sheets ─────────────────────────────────────────
            VStack {
                Spacer()
                if showDeliveryOptions {
                    deliveryOptionsSheet
                        .transition(.move(edge: .bottom))
                } else {
                    confirmLocationSheet
                        .transition(.move(edge: .bottom))
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: showDeliveryOptions)
            .ignoresSafeArea(edges: .bottom)
        }
        .onAppear {
            // Start GPS immediately on appear
            locationManager.requestLocation()
        }
        // ✅ KEY FIX: This fires when GPS finally gets a real fix
        .onChange(of: locationManager.lastLocation) { _, loc in
            guard let loc else { return }
            let coord = loc.coordinate

            // ✅ If user already tapped "Use current location" while GPS was loading,
            //    now jump the map to their real location
            if pendingJumpToCurrentLocation {
                pendingJumpToCurrentLocation = false
                jumpMapToCoord(coord)
                withAnimation {
                    showDeliveryOptions = false
                    showConfirmSheet = true
                }
            }

            // Always hide GPS spinner
            isWaitingForGPS = false
        }
        .alert("Location Access Denied",
               isPresented: $locationManager.showPermissionAlert) {
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Please enable location in Settings so we can find you.")
        }
        .onTapGesture { searchFocused = false }
    }

    // MARK: - Sheet 1: Delivery Options

    private var deliveryOptionsSheet: some View {
        VStack(alignment: .leading, spacing: 20) {
            dragHandle

            VStack(alignment: .leading, spacing: 6) {
                Text("Where do you want us to deliver the order?")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                Text("This will help with the right map location")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }

            // Away from location — use wherever map currently is
            Button {
                reverseGeocode(centerCoord)
                withAnimation { showDeliveryOptions = false; showConfirmSheet = true }
            } label: {
                Text("Away from my location")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.blue)
                    .cornerRadius(14)
            }

            // Use current location — waits for GPS if needed
            Button {
                handleUseCurrentLocation()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "location.circle")
                        .font(.system(size: 16))
                    Text("Use current location")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.blue, lineWidth: 1.5))
            }

            Spacer().frame(height: 4)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 34)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 12, y: -4)
        )
    }

    // MARK: - Sheet 2: Confirm Location

    private var confirmLocationSheet: some View {
        VStack(alignment: .leading, spacing: 16) {
            dragHandle

            Text("Deliver To")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)

            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.red)
                    .padding(.top, 2)

                VStack(alignment: .leading, spacing: 4) {
                    if isResolving {
                        HStack(spacing: 8) {
                            ProgressView().scaleEffect(0.75)
                            Text("Detecting location...")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                    } else {
                        Text(resolvedAddress)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Text(String(format: "%.6f, %.6f", centerCoord.latitude, centerCoord.longitude))
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
            }

            Button {
                vm.onMapLocationConfirmed(
                    latitude:  centerCoord.latitude,
                    longitude: centerCoord.longitude,
                    address:   resolvedAddress
                )
            } label: {
                Text("Confirm Location")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(isConfirmDisabled
                                ? Color("AppGreenColor").opacity(0.4)
                                : Color("AppGreenColor"))
                    .cornerRadius(14)
            }
            .disabled(isConfirmDisabled)

            Spacer().frame(height: 4)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 34)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 12, y: -4)
        )
    }

    // MARK: - Shared UI

    private var dragHandle: some View {
        HStack {
            Spacer()
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.gray.opacity(0.35))
                .frame(width: 36, height: 4)
            Spacer()
        }
    }

    private var isConfirmDisabled: Bool {
        isResolving
            || resolvedAddress == "Detecting location..."
            || resolvedAddress == "Unknown location"
    }

    // MARK: - Core Fix: Handle "Use Current Location" tap

    private func handleUseCurrentLocation() {
        if let loc = locationManager.lastLocation {
            // ✅ GPS already ready — jump immediately
            jumpMapToCoord(loc.coordinate)
            withAnimation { showDeliveryOptions = false; showConfirmSheet = true }
        } else {
            // ✅ GPS not ready yet — show spinner, set pending flag, wait
            isWaitingForGPS            = true
            pendingJumpToCurrentLocation = true
            locationManager.requestLocation()
            // onChange(of: lastLocation) will fire when GPS is ready
            // and will jump the map + open confirm sheet automatically
        }
    }

    // MARK: - Helpers

    private func jumpMapToCoord(_ coord: CLLocationCoordinate2D) {
        isWaitingForGPS = false
        centerCoord = coord
        region = MKCoordinateRegion(
            center: coord,
            span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        )
        reverseGeocode(coord)
    }

    private func performSearch() {
        guard !searchText.isEmpty else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = region
        MKLocalSearch(request: request).start { response, _ in
            DispatchQueue.main.async {
                searchResults = response?.mapItems ?? []
            }
        }
    }

    private func selectSearchResult(_ item: MKMapItem) {
        let coord = item.placemark.coordinate
        searchText    = item.name ?? ""
        searchResults = []
        searchFocused = false
        jumpMapToCoord(coord)
        withAnimation { showDeliveryOptions = false; showConfirmSheet = true }
    }

    private func reverseGeocode(_ coord: CLLocationCoordinate2D) {
        geocoder.cancelGeocode()
        isResolving = true
        let location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, _ in
            DispatchQueue.main.async {
                isResolving = false
                if let p = placemarks?.first {
                    var parts: [String] = []
                    if let sub     = p.subThoroughfare    { parts.append(sub) }
                    if let thor    = p.thoroughfare        { parts.append(thor) }
                    if let area    = p.subLocality         { parts.append(area) }
                    if let city    = p.locality            { parts.append(city) }
                    if let state   = p.administrativeArea  { parts.append(state) }
                    if let pin     = p.postalCode          { parts.append(pin) }
                    if let country = p.country             { parts.append(country) }
                    resolvedAddress = parts.joined(separator: ", ")
                } else {
                    resolvedAddress = "Unknown location"
                }
            }
        }
    }
}

// MARK: - MapView (UIViewRepresentable)

struct MapView: UIViewRepresentable {

    @Binding var region: MKCoordinateRegion
    var onRegionChanged: (CLLocationCoordinate2D) -> Void

    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.delegate          = context.coordinator
        map.showsUserLocation = true
        map.setRegion(region, animated: false)
        return map
    }

    func updateUIView(_ map: MKMapView, context: Context) {
        let delta = abs(map.region.center.latitude  - region.center.latitude)
                  + abs(map.region.center.longitude - region.center.longitude)
        if delta > 0.0001 { map.setRegion(region, animated: true) }
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        var debounceTimer: Timer?
        init(_ parent: MapView) { self.parent = parent }
        deinit { debounceTimer?.invalidate() }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            let center = mapView.region.center
            parent.region = mapView.region
            debounceTimer?.invalidate()
            debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { _ in
                DispatchQueue.main.async { self.parent.onRegionChanged(center) }
            }
        }
    }
}

// MARK: - MapLocationManager

class MapLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    @Published var lastLocation:       CLLocation?
    @Published var showPermissionAlert = false

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate        = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter  = kCLDistanceFilterNone  // get every update
    }

    func requestLocation() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            showPermissionAlert = true
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        // ✅ Accept any fix with valid (positive) accuracy
        // Take the best (lowest) accuracy reading from the batch
        let validLocations = locations.filter { $0.horizontalAccuracy > 0 }
        guard let best = validLocations.min(by: { $0.horizontalAccuracy < $1.horizontalAccuracy })
        else { return }

        lastLocation = best

        // Stop once we have a reasonably accurate fix
        if best.horizontalAccuracy < 100 {
            manager.stopUpdatingLocation()
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            showPermissionAlert = true
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}
