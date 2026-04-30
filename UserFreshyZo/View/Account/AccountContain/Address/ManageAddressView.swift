//
//  ManageAddressView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 06/04/26.
//

import SwiftUI

// MARK: - ManageAddressView (Main)

struct ManageAddressView: View {

    @StateObject private var vm  = AddressViewModel()
    @Environment(\.dismiss) private var dismiss
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                AddressNavBar(onBack: { dismiss() })

                ScrollView {
                    VStack(spacing: 16) {
                        // ── Section header ────────────────────────────
                        if !vm.addresses.isEmpty {
                            HStack {
                                Text("SAVED ADDRESSES")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(.gray)
                                    .tracking(1)
                                Spacer()
                            }
                            .padding(.horizontal, isPad ? 24 : 16)
                            .padding(.top, 20)
                        }

                        // ── Address cards ─────────────────────────────
                        ForEach(vm.addresses) { address in
                            AddressCard(
                                address: address,
                                onEdit:       { vm.initiateEdit(address: address) },
                                onDelete:     { vm.deleteAddress(id: address.id) },
                                onSetDefault: { vm.setDefault(id: address.id) }
                            )
                            .padding(.horizontal, isPad ? 24 : 16)
                        }

                        // ── Add New Address button ─────────────────────
                        AddNewAddressButton {
                            vm.initiateAddAddress()
                        }
                        .padding(.horizontal, isPad ? 24 : 16)
                        .padding(.top, vm.addresses.isEmpty ? 32 : 0)
                        .padding(.bottom, 32)
                    }
                }
                .background(Color(UIColor.systemGroupedBackground))
            }

            // ── Toast ─────────────────────────────────────────────────
            if vm.showToast {
                AddressToastBanner(message: vm.toastMessage)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(3)
            }
        }
        .navigationBarHidden(true)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: vm.showToast)

        // ── Map picker (full screen) ──────────────────────────────────
        .fullScreenCover(isPresented: $vm.showMapPicker) {
            AddressMapPickerView(vm: vm)
        }

        // ── Edit / Add sheet ──────────────────────────────────────────
        .sheet(isPresented: $vm.showEditSheet) {
            AddressEditSheet(vm: vm)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    NavigationStack {
        ManageAddressView()
    }
}
