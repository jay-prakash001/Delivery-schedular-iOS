//
//  ProfileSubViews.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 28/03/26.
//

import SwiftUI
import UIKit

// MARK: - ProfileHeaderView

struct ProfileHeaderView: View {
    var onBack: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onBack) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "#F2F2F2"))
                        .frame(width: 36, height: 36)
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "#1C1C1E"))
                }
            }
            Text("Profile")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(hex: "#1C1C1E"))
            Spacer()
        }
    }
}

// MARK: - ProfileImageSectionView

struct ProfileImageSectionView: View {
    @ObservedObject var vm: AccountViewModel

    var body: some View {
        VStack(spacing: 10) {
            Button(action: {
                vm.showImagePicker = true
            }) {
                ZStack(alignment: .bottomTrailing) {
                    if let image = vm.profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color(hex: "#F2F2F2"))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 44, height: 44)
                                    .foregroundColor(Color(hex: "#AAAAAA"))
                            )
                    }

                    // Camera badge
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#2E8B72"))
                            .frame(width: 28, height: 28)
                        Image(systemName: "camera.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                    }
                    .offset(x: 4, y: 4)
                }
            }

            Text(vm.name.isEmpty ? "User Name" : vm.name)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(hex: "#1C1C1E"))
        }
        .padding(.top, 8)
    }
}

// MARK: - ProfileFormSectionView

struct ProfileFormSectionView: View {
    @ObservedObject var vm: AccountViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("PERSONAL INFO")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Color(hex: "#2E8B72"))
                .tracking(1.4)

            ProfileFieldLabel("Name")
            ProfileInputField(
                icon: "person.fill",
                iconColor: Color(hex: "#1A1A1A"),
                placeholder: "User Name",
                text: $vm.name
            )

            ProfileFieldLabel("Phone Number")
            ProfileInputField(
                icon: "iphone",
                iconColor: Color(hex: "#1A80B0"),
                placeholder: "Phone Number",
                text: $vm.phoneNumber,
                keyboardType: .phonePad
            )

            ProfileFieldLabel("Date of Birth")
            ProfileDateField(vm: vm)

            ProfileFieldLabel("Email Address")
            ProfileInputField(
                icon: "envelope.fill",
                iconColor: Color(hex: "#1A6B55"),
                placeholder: "Email Address",
                text: $vm.email,
                keyboardType: .emailAddress
            )
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - ProfileFieldLabel

struct ProfileFieldLabel: View {
    let text: String
    init(_ text: String) { self.text = text }

    var body: some View {
        Text(text)
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(Color(hex: "#1C1C1E"))
    }
}

// MARK: - ProfileInputField

struct ProfileInputField: View {
    let icon: String
    let iconColor: Color
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 20)
            TextField(placeholder, text: $text)
                .font(.system(size: 15))
                .keyboardType(keyboardType)
                .autocapitalization(.none)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "#E0E0E0"), lineWidth: 1)
        )
    }
}

// MARK: - ProfileDateField

struct ProfileDateField: View {
    @ObservedObject var vm: AccountViewModel
    @State private var showDatePicker = false

    var body: some View {
        VStack(spacing: 0) {
            Button(action: { showDatePicker.toggle() }) {
                HStack(spacing: 12) {
                    Text("🎂")
                        .font(.system(size: 16))
                    Text(vm.formattedDate)
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "#1C1C1E"))
                    Spacer()
                    Image(systemName: showDatePicker ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "#E0E0E0"), lineWidth: 1)
                )
            }
            .buttonStyle(PlainButtonStyle())

            if showDatePicker {
                DatePicker("",
                           selection: $vm.dateOfBirth,
                           displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .padding(.horizontal, 8)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: "#E0E0E0"), lineWidth: 1)
                    )
            }
        }
    }
}

// MARK: - SaveButtonView

struct SaveButtonView: View {
    @ObservedObject var vm: AccountViewModel

    var body: some View {
        Button(action: { vm.saveChanges() }) {
            HStack(spacing: 10) {
                Text(vm.isSaved ? "Saved!" : "Save Changes")
                    .font(.system(size: 15, weight: .bold))
                Image(systemName: vm.isSaved ? "checkmark" : "arrow.right")
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(.white)
//            .frame(maxWidth: .infinity)
            .frame(width: 200, height: 48)
            .frame(height: 52)
            .background(Color(hex: "#2E8B72"))
            .cornerRadius(18)
            .animation(.easeInOut(duration: 0.2), value: vm.isSaved)
        }
    }
}

// MARK: - ImagePickerView

struct ImagePickerView: UIViewControllerRepresentable {

    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: Context) {}

    class Coordinator: NSObject,
                       UIImagePickerControllerDelegate,
                       UINavigationControllerDelegate {

        let parent: ImagePickerView

        init(_ parent: ImagePickerView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.isPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}

