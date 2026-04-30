//
//  AddressNavBar.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 06/04/26.
//

import SwiftUI

// MARK: - AddressNavBar

struct AddressNavBar: View {

    let onBack: () -> Void
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
            Spacer()
            Text("Manage Address")
                .font(.system(size: isPad ? 20 : 17, weight: .bold))
                .foregroundColor(.white)
            Spacer()
            Color.clear.frame(width: 36, height: 36)
        }
        .padding(.horizontal, isPad ? 24 : 16)
        .padding(.vertical, 14)
        .background(Color("AppGreenColor"))
    }
}

// MARK: - AddressCard

struct AddressCard: View {

    let address:      UserAddress
    let onEdit:       () -> Void
    let onDelete:     () -> Void
    let onSetDefault: () -> Void

    @State private var showDeleteConfirm = false
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // ── Default badge ─────────────────────────────────────────
            if address.isDefault {
                HStack {
                    HStack(spacing: 5) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                        Text("Default")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(Color("AppGreenColor"))
                    .clipShape(Capsule())
                    Spacer()
                }
                .padding(.horizontal, 14)
                .padding(.top, 14)
            }

            // ── Name row + Edit button ────────────────────────────────
            HStack(alignment: .center, spacing: 10) {
                // Type icon
                ZStack {
                    Circle()
                        .fill(Color("AppGreenColor").opacity(0.1))
                        .frame(width: 40, height: 40)
                    Image(systemName: address.addressType.icon)
                        .font(.system(size: 16))
                        .foregroundColor(Color("AppGreenColor"))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(address.name)
                        .font(.system(size: isPad ? 16 : 15, weight: .bold))
                        .foregroundColor(.primary)
                    Text(address.addressType.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color("AppGreenColor"))
                }

                Spacer()

                // Edit button
                Button(action: onEdit) {
                    HStack(spacing: 4) {
                        Image(systemName: "pencil")
                            .font(.system(size: 12))
                        Text("Edit")
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundColor(.red.opacity(0.8))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.red.opacity(0.08))
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal, 14)
            .padding(.top, address.isDefault ? 10 : 14)

            Divider()
                .padding(.horizontal, 14)
                .padding(.top, 10)

            // ── Address details ───────────────────────────────────────
            VStack(alignment: .leading, spacing: 8) {
                // Full address
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.red)
                        .padding(.top, 1)
                    Text(address.fullAddress)
                        .font(.system(size: isPad ? 14 : 13))
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                // Coordinates
                HStack(spacing: 10) {
                    Image(systemName: "globe")
                        .font(.system(size: 14))
                        .foregroundColor(.blue.opacity(0.7))
                    Text(address.coordinateText)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }

                // Phone
                HStack(spacing: 10) {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 14))
                        .foregroundColor(Color("AppGreenColor"))
                    Text(address.phone)
                        .font(.system(size: isPad ? 14 : 13))
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)

            // ── Bottom actions (Set Default / Delete) ─────────────────
            if !address.isDefault {
                Divider().padding(.horizontal, 14)
                HStack(spacing: 0) {
                    Button(action: onSetDefault) {
                        HStack(spacing: 5) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                            Text("Set as Default")
                                .font(.system(size: 13, weight: .medium))
                        }
                        .foregroundColor(Color("AppGreenColor"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                    }
                    Divider().frame(height: 32)
                    Button {
                        showDeleteConfirm = true
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: "trash")
                                .font(.system(size: 12))
                            Text("Delete")
                                .font(.system(size: 13, weight: .medium))
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                    }
                }
                .padding(.bottom, 4)
            } else {
                Spacer().frame(height: 14)
            }
        }
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
        .shadow(color: .black.opacity(0.05), radius: 6, y: 2)
        .confirmationDialog("Delete this address?",
                            isPresented: $showDeleteConfirm,
                            titleVisibility: .visible) {
            Button("Delete", role: .destructive, action: onDelete)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
    }
}

// MARK: - AddNewAddressButton

struct AddNewAddressButton: View {

    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("AppGreenColor").opacity(0.12))
                        .frame(width: 40, height: 40)
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("AppGreenColor"))
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Add New Address")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)
                    Text("Save home, work or other locations")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(
                                Color("AppGreenColor").opacity(0.4),
                                style: StrokeStyle(lineWidth: 1.5, dash: [6, 3])
                            )
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - AddressToastBanner

struct AddressToastBanner: View {
    let message: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color("AppGreenColor"))
            Text(message)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black.opacity(0.12), radius: 12, y: 4)
        )
        .padding(.bottom, 28)
        .padding(.horizontal, 24)
    }
}

#Preview {
    VStack(spacing: 16) {
        AddressCard(
            address: UserAddress(
                id: "1", name: "Levi Ackerman", phone: "+91 91795 93730",
                fullAddress: "G-4, Shri Ram Nagar, Shankar Nagar, Raipur, Chhattisgarh 492004, India",
                latitude: 21.249137, longitude: 81.667989,
                addressType: .home, isDefault: true
            ),
            onEdit: {}, onDelete: {}, onSetDefault: {}
        )
        .padding()
        AddNewAddressButton(onTap: {})
            .padding()
    }
    .background(Color(UIColor.systemGroupedBackground))
}
