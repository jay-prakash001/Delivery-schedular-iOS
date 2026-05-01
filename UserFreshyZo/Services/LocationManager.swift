//
//  LocationManager.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 01/05/26.
//

import Foundation


import SwiftUI
import GoogleMaps
import CoreLocation
import Combine
import Contacts

// MARK: - Location Manager
@MainActor
final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published var selectedCoordinate: CLLocationCoordinate2D?
    @Published var address: String = "Move map to select"
    @Published var isFetching: Bool = false
    private var geocodeTask: Task<Void, Never>?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestPermission() {
        let status = manager.authorizationStatus
        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        // Update coordinates which triggers the updateUIView animation
        selectedCoordinate = location.coordinate
        updateAddress(for: location.coordinate)
        
        manager.stopUpdatingLocation()
    }
    func updateAddress(for coordinate: CLLocationCoordinate2D) {
        geocodeTask?.cancel()
        let gmsGeocoder = GMSGeocoder()

        geocodeTask = Task {
            await MainActor.run { self.isFetching = true }
            
            gmsGeocoder.reverseGeocodeCoordinate(coordinate) { response, error in
                Task { @MainActor in
                    guard let address = response?.firstResult() else {
                        self.address = "Address not found"
                        self.isFetching = false
                        return
                    }

                    // Use an array to keep track of unique components in order
                    var uniqueComponents: [String] = []

                    // Helper function to add parts without duplication
                    func addComponent(_ value: String?) {
                        guard let value = value?.trimmingCharacters(in: .whitespacesAndNewlines), !value.isEmpty else { return }
                        
                        // Only add if this component isn't already contained in what we've collected
                        // and isn't a duplicate of a previous entry
                        if !uniqueComponents.contains(where: { $0.localizedCaseInsensitiveContains(value) || value.localizedCaseInsensitiveContains($0) }) {
                            uniqueComponents.append(value)
                        }
                    }

                    // 1. Start with Google's most specific formatted line (usually the landmark/building)
                    if let firstLine = address.lines?.first {
                        addComponent(firstLine)
                    }

                    // 2. Add Thoroughfare (Landmark/Street) if not already captured
                    addComponent(address.thoroughfare)

                    // 3. Add Area/Neighborhood
                    addComponent(address.subLocality)

                    // 4. Add City
                    addComponent(address.locality)

                    // 5. Add State
                    addComponent(address.administrativeArea)

                    // 6. Add Zip Code
                    addComponent(address.postalCode)

                    // Final Assembly
                    let finalAddress = uniqueComponents.joined(separator: ", ")

                    self.address = finalAddress.isEmpty ? "Location not recognized" : finalAddress
                    self.isFetching = false
                }
            }
        }
    }
    
    func updateAddress0(for coordinate: CLLocationCoordinate2D) {
        geocodeTask?.cancel()
        
        // Use Google's Geocoder (Included for free with GoogleMaps SDK)
        let gmsGeocoder = GMSGeocoder()

        geocodeTask = Task {
            await MainActor.run { self.isFetching = true }
            
            gmsGeocoder.reverseGeocodeCoordinate(coordinate) { response, error in
                Task { @MainActor in
                    // Check if we got a result
                    if let address = response?.firstResult() {
                        
                        // 1. Google's 'lines' property is the direct equivalent
                        // to Android's getAddressLine(0).
                        // It often includes the landmark/building name automatically.
                        let fullAddress = address.lines?.joined(separator: ", ") ?? ""
                        
                        // 2. If 'lines' feels too short, we can check 'thoroughfare'
                        // which Google often uses for building/landmark names.
                        self.address = fullAddress.isEmpty ? "Location not recognized" : fullAddress
                        
                        self.isFetching = false
                    } else {
                        // Fallback if no result found
                        self.address = "Address not found"
                        self.isFetching = false
                    }
                }
            }
        }
    }
}

