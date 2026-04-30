//
//  WelcomeCardView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 28/03/26.
//

import SwiftUI

// MARK: - WelcomeCardView
// WelcomeCardView.swift

import SwiftUI

struct WelcomeCardView: View {
    @ObservedObject var vm: AccountViewModel
    
    var body: some View {
        NavigationLink(destination: ProfileView(vm: vm)) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#A8D4B4"))
                        .frame(width: 64, height: 64)
                    
                    if let image = vm.profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "leaf.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color(hex: "#1A6B55"))
                            .frame(width: 28, height: 28)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text("Welcome, \(vm.name)")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "#1C1C1E"))
                        Text("👋")
                            .font(.system(size: 16))
                    }
                    Text("Manage your account & find useful links below.")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color.gray.opacity(0.35))
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

