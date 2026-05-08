//
//  AddReviewDialog.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 08/05/26.
//

import SwiftUI

struct AddReviewDialog: View {
    @Binding var isPresented: Bool
    @State private var rating: Int = 0
    @State private var comment: String = ""
    
    var onSave: (Int, String) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // 1. HEADER
            Text("Add Feedback")
                .font(.headline)
                .padding(.top)
            
            // 2. INTERACTIVE STAR RATING
            VStack(spacing: 8) {
                Text("Your Rating")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= rating ? "star.fill" : "star")
                            .font(.system(size: 30))
                            .foregroundColor(index <= rating ? .orange : .gray.opacity(0.4))
                            .onTapGesture {
                                rating = index
                            }
                    }
                }
            }
            
            // 3. TEXT AREA (Comment)
            VStack(alignment: .leading, spacing: 8) {
                Text("Write your review")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextEditor(text: $comment)
                    .frame(height: 100)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            }
            
            // 4. ACTION BUTTONS
            HStack(spacing: 15) {
                Button("Cancel") {
                    isPresented = false
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                Button("Submit") {
                    onSave(rating, comment)
                    isPresented = false
                }
                .disabled(rating == 0) // Require a rating
                .frame(maxWidth: .infinity)
                .padding()
                .background(rating == 0 ? Color.gray : Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
        .padding(.horizontal, 30)
    }
}




#Preview {
    ZStack {
        Color.gray.opacity(0.3).ignoresSafeArea()
        
        // Simulating the dialog as it would appear when showFeedbackDialog is true
        AddReviewDialog(isPresented: .constant(true)) { rating, comment in
            print("Rating: \(rating), Comment: \(comment)")
        }
    }
}
