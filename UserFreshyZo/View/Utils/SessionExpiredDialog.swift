import SwiftUI

struct SessionExpiredDialog: View {
    var onLoginAgain: () -> Void
    
    var body: some View {
        ZStack {
            // 1. Background Overlay
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            // 2. The Dialog Card
            VStack(spacing: 24) {
                
                // Icon and Text Section
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.red)
                        .padding(.top, 10)
                    
                    VStack(spacing: 8) {
                        Text("Session Expired")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Text("Your security token is no longer valid. Please log in again to continue.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10)
                    }
                }
                
                // 3. The Distinct Red Button
                Button(action: {
                    onLoginAgain()
                }) {
                    Text("Log In Again")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.red)
                        .cornerRadius(12) // Rounded corners make it look like a button
                        .shadow(color: .red.opacity(0.3), radius: 5, x: 0, y: 3)
                }
                .padding(.horizontal, 20) // Adds space so it doesn't touch the card edges
                .padding(.bottom, 20)      // Adds space at the bottom of the card
            }
            .padding(10)
            .background(Color(.systemBackground))
            .cornerRadius(24)
            .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 45) // Controls how wide the dialog is on the screen
        }
    }
}
