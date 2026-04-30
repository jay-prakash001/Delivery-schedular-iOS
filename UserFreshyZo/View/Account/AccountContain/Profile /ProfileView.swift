//
//  ProfileView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 28/03/26.
//


import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var vm: AccountViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            
            ProfileHeaderView(onBack: { dismiss() })
                .padding()
                .background(Color.white)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    ProfileImageSectionView(vm: vm)
                    ProfileFormSectionView(vm: vm)
                    SaveButtonView(vm: vm)
                    Spacer().frame(height: 40)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
        }
        .sheet(isPresented: $vm.showImagePicker) {
            ImagePickerView(selectedImage: $vm.profileImage,
                            isPresented: $vm.showImagePicker)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    ProfileView(vm: AccountViewModel())  // ← fix: pass a vm instance
}
