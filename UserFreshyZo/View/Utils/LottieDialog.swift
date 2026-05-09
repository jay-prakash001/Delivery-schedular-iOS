//
//  LottieDialog.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 09/05/26.
//

import Foundation

import Lottie
import SwiftUI

struct LottieDialog: View {
    @Binding var isPresented: Bool
    
    // Configuration
    var lottieFileName: String
    var title: String?
    var message: String?
    var primaryButtonText: String? = "OK"
    var secondaryButtonText: String? = nil
    
    // Actions
    var onPrimaryAction: (() -> Void)? = nil
    var onSecondaryAction: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            // Lottie Animation
            LottieView(name: lottieFileName)
                .frame(width: 150, height: 150)
            
            VStack(spacing: 8) {
                if let title = title {
                    Text(title)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                }
                
                if let message = message {
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            HStack(spacing: 12) {
                // Optional Secondary Button
                if let secondaryText = secondaryButtonText {
                    Button(action: {
                        onSecondaryAction?()
                        isPresented = false
                    }) {
                        Text(secondaryText)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .foregroundColor(.primary)
                            .cornerRadius(12)
                    }
                }
                
                // Optional Primary Button
                if let primaryText = primaryButtonText {
                    Button(action: {
                        onPrimaryAction?()
                        isPresented = false
                    }) {
                        Text(primaryText)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange) // Or your brand color
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
            }
        }
        .padding(24)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.15), radius: 20)
        .padding(.horizontal, 40)
    }
}



#Preview("Success State") {
    ZStack {
        Color.gray.opacity(0.3).ignoresSafeArea()
        
        LottieDialog(
            isPresented: .constant(true),
            lottieFileName: "empty_cart", // Ensure this exists in your project
            title: "Thank You!",
            message: "Your review has been successfully submitted.",
            primaryButtonText: "Done",
            onPrimaryAction: { print("Closed") }
        )
    }
}

#Preview("Choice State") {
    ZStack {
        Color.gray.opacity(0.3).ignoresSafeArea()
        
        LottieDialog(
            isPresented: .constant(true),
            lottieFileName: "empty_cart",
            title: "Discard Changes?",
            message: "Are you sure you want to go back? Your review will not be saved.",
            primaryButtonText: "Keep Editing",
            secondaryButtonText: "Discard",
            onPrimaryAction: { print("Staying") },
            onSecondaryAction: { print("Discarded") }
        )
    }
}
