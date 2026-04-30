//
//  AddressViewModel.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 06/04/26.
//

import Foundation
import CoreLocation
import Combine

@MainActor
final class AddressViewModel: ObservableObject {

    // MARK: - Published State

    @Published var addresses:         [UserAddress]  = []
    @Published var isLoading:         Bool           = false
    @Published var errorMessage:      String?        = nil
    @Published var showToast:         Bool           = false
    @Published var toastMessage:      String         = ""

    // ── Add / Edit sheet ──────────────────────────────────────────────
    @Published var showMapPicker:     Bool           = false   // open map to pick location
    @Published var showEditSheet:     Bool           = false   // open edit bottom sheet
    @Published var addressToEdit:     UserAddress?   = nil     // nil = new address

    // ── Map picker state ──────────────────────────────────────────────
    @Published var pickedLatitude:    Double         = 0.0
    @Published var pickedLongitude:   Double         = 0.0
    @Published var pickedAddressText: String         = ""

    // ── Edit form fields ──────────────────────────────────────────────
    @Published var formName:        String      = ""
    @Published var formPhone:       String      = ""
    @Published var formAddress:     String      = ""
    @Published var formType:        AddressType = .home
    @Published var formIsDefault:   Bool        = false

    // MARK: - Init

    init() {
        loadMockData()
        // Replace with: Task { await fetchAddresses() }
    }

    // MARK: - Mock Data

    private func loadMockData() {
        addresses = [
            UserAddress(
                id:          "1",
                name:        "Levi Ackerman",
                phone:       "+91 91795 93730",
                fullAddress: "G-4, Shri Ram Nagar, Shankar Nagar, Raipur, Chhattisgarh 492004, India",
                latitude:    21.249137,
                longitude:   81.667989,
                addressType: .home,
                isDefault:   true
            )
        ]
    }

    // MARK: - Initiate Add (opens map)

    func initiateAddAddress() {
        addressToEdit     = nil
        formName          = ""
        formPhone         = ""
        formAddress       = ""
        formType          = .home
        formIsDefault     = addresses.isEmpty   // auto-default if first address
        pickedLatitude    = 0.0
        pickedLongitude   = 0.0
        pickedAddressText = ""
        showMapPicker     = true
    }

    // MARK: - Map confirmed → open edit sheet pre-filled

    func onMapLocationConfirmed(latitude: Double, longitude: Double, address: String) {
        pickedLatitude    = latitude
        pickedLongitude   = longitude
        pickedAddressText = address
        formAddress       = address
        showMapPicker     = false
        showEditSheet     = true
    }

    // MARK: - Initiate Edit (opens edit sheet directly, no map)

    func initiateEdit(address: UserAddress) {
        addressToEdit   = address
        formName        = address.name
        formPhone       = address.phone
        formAddress     = address.fullAddress
        formType        = address.addressType
        formIsDefault   = address.isDefault
        pickedLatitude  = address.latitude
        pickedLongitude = address.longitude
        showEditSheet   = true
    }

    // MARK: - Save (Add or Update)

    func saveAddress() {
        guard !formName.isEmpty, !formAddress.isEmpty else {
            errorMessage = "Please fill in all required fields."
            return
        }

        if let editing = addressToEdit,
           let idx = addresses.firstIndex(where: { $0.id == editing.id }) {
            // ── Update existing ───────────────────────────────────────
            var updated          = addresses[idx]
            updated.name         = formName
            updated.phone        = formPhone
            updated.fullAddress  = formAddress
            updated.addressType  = formType
            updated.latitude     = pickedLatitude
            updated.longitude    = pickedLongitude
            if formIsDefault { setDefaultLocally(id: editing.id) }
            updated.isDefault    = formIsDefault
            addresses[idx]       = updated
            showToastMessage("Address updated successfully")
        } else {
            // ── Add new ───────────────────────────────────────────────
            let newId = UUID().uuidString
            if formIsDefault { setDefaultLocally(id: newId) }
            let newAddress = UserAddress(
                id:          newId,
                name:        formName,
                phone:       formPhone,
                fullAddress: formAddress,
                latitude:    pickedLatitude,
                longitude:   pickedLongitude,
                addressType: formType,
                isDefault:   formIsDefault || addresses.isEmpty
            )
            addresses.append(newAddress)
            showToastMessage("Address added successfully")
        }

        showEditSheet = false
        addressToEdit = nil

        // ── API call (uncomment when ready) ───────────────────────────
        /*
        Task {
            await callSaveAddress(SaveAddressRequest(
                id:          addressToEdit?.id,
                name:        formName,
                phone:       formPhone,
                fullAddress: formAddress,
                latitude:    pickedLatitude,
                longitude:   pickedLongitude,
                addressType: formType.rawValue,
                isDefault:   formIsDefault
            ))
        }
        */
    }

    // MARK: - Delete

    func deleteAddress(id: String) {
        addresses.removeAll { $0.id == id }
        showToastMessage("Address removed")

        // ── API call (uncomment when ready) ───────────────────────────
        /*
        Task { await callDeleteAddress(DeleteAddressRequest(addressId: id)) }
        */
    }

    // MARK: - Set Default

    func setDefault(id: String) {
        setDefaultLocally(id: id)
        showToastMessage("Default address updated")
    }

    // MARK: - Dismiss Edit Sheet

    func dismissEditSheet() {
        showEditSheet = false
        addressToEdit = nil
    }

    // MARK: - Private Helpers

    private func setDefaultLocally(id: String) {
        for idx in addresses.indices {
            addresses[idx].isDefault = addresses[idx].id == id
        }
    }

    private func showToastMessage(_ msg: String) {
        toastMessage = msg
        showToast    = true
        Task {
            try? await Task.sleep(nanoseconds: 2_500_000_000)
            showToast = false
        }
    }

    // MARK: - API Helpers (uncomment when backend ready)

    /*
    func fetchAddresses() async {
        isLoading = true
        defer { isLoading = false }
        do {
            guard let url = URL(string: "https://freshyzo.com/admin/Customer_App_Api/get_addresses") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            let response  = try JSONDecoder().decode(FetchAddressesResponse.self, from: data)
            if response.success { addresses = response.addresses }
            else { errorMessage = response.message }
        } catch { errorMessage = "Failed to load addresses." }
    }

    private func callSaveAddress(_ request: SaveAddressRequest) async {
        do {
            guard let url = URL(string: "https://freshyzo.com/admin/Customer_App_Api/save_address") else { return }
            var req = URLRequest(url: url)
            req.httpMethod = "POST"
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req.httpBody  = try JSONEncoder().encode(request)
            let (data, _) = try await URLSession.shared.data(for: req)
            let response  = try JSONDecoder().decode(AddressActionResponse.self, from: data)
            if !response.success { errorMessage = response.message }
        } catch { errorMessage = "Failed to save address." }
    }

    private func callDeleteAddress(_ request: DeleteAddressRequest) async {
        do {
            guard let url = URL(string: "https://freshyzo.com/admin/Customer_App_Api/delete_address") else { return }
            var req = URLRequest(url: url)
            req.httpMethod = "POST"
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req.httpBody  = try JSONEncoder().encode(request)
            let (data, _) = try await URLSession.shared.data(for: req)
            let response  = try JSONDecoder().decode(AddressActionResponse.self, from: data)
            if !response.success { errorMessage = response.message }
        } catch { errorMessage = "Failed to delete address." }
    }
    */
}
