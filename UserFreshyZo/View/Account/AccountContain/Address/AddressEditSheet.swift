//
//  AddressEditSheet.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 06/04/26.
//

import SwiftUI

// MARK: - AddressEditSheet

struct AddressEditSheet: View {

    @ObservedObject var vm: AddressViewModel
    private let isPad   = UIDevice.current.userInterfaceIdiom == .pad
    private var isEditing: Bool { vm.addressToEdit != nil }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // ── Header ────────────────────────────────────────────────
            VStack(alignment: .leading, spacing: 4) {
                Text(isEditing ? "Edit Address" : "Add New Address")
                    .font(.system(size: isPad ? 20 : 18, weight: .bold))
                if !isEditing {
                    Text("Fill in the details for your new address")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top, 24)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)

            Divider()

            ScrollView {
                VStack(spacing: 16) {

                    // ── Full Address (pre-filled from map) ────────────
                    AddressFormField(
                        title:       "Full Address",
                        placeholder: "Address",
                        text:        $vm.formAddress,
                        isMultiline: true
                    )

                    // ── Name ──────────────────────────────────────────
                    AddressFormField(
                        title:       "Full Name",
                        placeholder: "Enter your name",
                        text:        $vm.formName
                    )

                    // ── Phone ─────────────────────────────────────────
                    AddressFormField(
                        title:       "Phone Number",
                        placeholder: "+91 XXXXX XXXXX",
                        text:        $vm.formPhone,
                        keyboardType: .phonePad
                    )

                    // ── Address Type ──────────────────────────────────
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Address Type")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)

                        HStack(spacing: 10) {
                            ForEach(AddressType.allCases) { type in
                                AddressTypeChip(
                                    type:       type,
                                    isSelected: vm.formType == type,
                                    onTap:      { vm.formType = type }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)

                    // ── Set as Default toggle ─────────────────────────
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Set as default address")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primary)
                            Text("This will be used for all deliveries")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Toggle("", isOn: $vm.formIsDefault)
                            .toggleStyle(SwitchToggleStyle(tint: Color("AppGreenColor")))
                            .labelsHidden()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 4)
                }
                .padding(.vertical, 16)
            }

            Divider()

            // ── Save button ───────────────────────────────────────────
            Button(action: vm.saveAddress) {
                Text(isEditing ? "Save Changes" : "Add Address")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        vm.formName.isEmpty || vm.formAddress.isEmpty
                            ? Color("AppGreenColor").opacity(0.5)
                            : Color("AppGreenColor")
                    )
                    .cornerRadius(14)
            }
            .disabled(vm.formName.isEmpty || vm.formAddress.isEmpty)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

// MARK: - AddressFormField

struct AddressFormField: View {

    let title:        String
    let placeholder:  String
    @Binding var text: String
    var isMultiline:  Bool         = false
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
                .padding(.horizontal, 20)

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.25), lineWidth: 1)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(UIColor.systemBackground))
                    )

                if isMultiline {
                    TextEditor(text: $text)
                        .font(.system(size: 14))
                        .frame(minHeight: 72)
                        .padding(10)
                        .scrollContentBackground(.hidden)
                        .overlay(
                            Group {
                                if text.isEmpty {
                                    Text(placeholder)
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(UIColor.placeholderText))
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 18)
                                        .allowsHitTesting(false)
                                }
                            },
                            alignment: .topLeading
                        )
                } else {
                    TextField(placeholder, text: $text)
                        .font(.system(size: 14))
                        .keyboardType(keyboardType)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 14)
                }
            }
            .frame(minHeight: isMultiline ? 90 : 48)
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - AddressTypeChip

struct AddressTypeChip: View {

    let type:       AddressType
    let isSelected: Bool
    let onTap:      () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Image(systemName: type.icon)
                    .font(.system(size: 13))
                Text(type.rawValue)
                    .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
            }
            .foregroundColor(isSelected ? Color("AppGreenColor") : .secondary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected
                          ? Color("AppGreenColor").opacity(0.1)
                          : Color(UIColor.systemGroupedBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                isSelected
                                    ? Color("AppGreenColor")
                                    : Color.gray.opacity(0.25),
                                lineWidth: 1.5
                            )
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AddressEditSheet(vm: AddressViewModel())
        .presentationDetents([.medium, .large])
}
