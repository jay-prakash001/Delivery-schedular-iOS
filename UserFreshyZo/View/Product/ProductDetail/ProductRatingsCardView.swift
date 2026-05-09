//
//  SubscriptionStepperView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 30/03/26.
//

//  ProductRatingsCardView.swift
//  UserFreshyZo

import SwiftUI

struct ProductRatingsCardView: View {
    let isPad: Bool
    let feedBacks : [Feedback]
    let canWriteFeedBack : Bool
    @State private var rating: Int = 5
    @State private var feedbackText: String = ""
    @State var showReviewSection = false
    
    @EnvironmentObject var mainRouter : MainRouter
    @EnvironmentObject var productViewModel : ProductViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                SectionHeader(title: "Ratings")
                Spacer()
                Button("See all →") {
                    
                    mainRouter.navigate(to: .allreview)
                    
                    
                }
                .font(.system(size: isPad ? 15 : 13, weight: .medium))
                .foregroundColor(Color("AppGreenColor"))
            }
            
            
            
            
            HStack(alignment: .center, spacing: 20) {
                let rating = avgRating(feedback: feedBacks)
                
                // Left Side: Rating Info
                VStack(spacing: 4) {
                    Text(String(format: "%.1f", rating))
                        .font(.system(size: isPad ? 48 : 38, weight: .bold))
                    
                    HStack(spacing: 2) {
                        ForEach(0..<5) { i in
                            let index = Double(i)
                            Image(systemName: rating >= index + 1 ? "star.fill" : (rating >= index + 0.5 ? "star.leadinghalf.filled" : "star"))
                                .foregroundColor(.orange)
                                .font(.system(size: isPad ? 14 : 11))
                        }
                    }
                }
                
                // THE MAGIC: This pushes everything after it to the extreme right
                Spacer()
                
                // Right Side: Review Button
                Button(action: {
                    withAnimation(.spring()) {
                        showReviewSection.toggle()
                    }
                }) {
                    Text("Write Review")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 24)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [.lightAppGreen, .secondGreen.opacity(0.8)]),
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing)
                        )
                        .clipShape(Capsule())
                        .shadow(color: .blue.opacity(0.2), radius: 4, x: 0, y: 2)
                }
            }
            if showReviewSection{
                // Inside your body:
                VStack {
                    if canWriteFeedBack {
                        ReviewInputView(
                            rating: $rating,
                            feedbackText: $feedbackText,
                            onSubmit: {
                                print("Review submitted: \(rating) stars, \(feedbackText)")
                                productViewModel.submitProductReview(rating: rating, feedbackText: feedbackText)
                                
                                withAnimation{
                                    showReviewSection = false // Close after submission
                                    feedbackText = ""
                                    rating = 5
                                }
                            },onClose: {
                                withAnimation{
                                    showReviewSection = false // Close after submission
                                    feedbackText = ""
                                    rating = 5
                                }
                            }
                        )
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    } else {
                        // "No Customer" State (Empty State UI)
                        NoAccessView()                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        
                    }
                }
                .animation(.easeInOut, value: showReviewSection)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(feedBacks, id: \.self.feedbackId) { fb in ReviewCard( isPad: isPad, feedback :fb ) }
                }
            }
        }
        
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 18).fill(Color.white))
        .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
        
        
    }
}




struct ReviewInputView: View {
    @Binding var rating: Int
    @Binding var feedbackText: String
    var onSubmit: () -> Void
    var onClose: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Rate this product")
                    .font(.headline)
                
                Spacer() // Pushes the close button to the right
                
                Button(action: {
                    onClose()
                }) {
                    Image(systemName: "xmark.circle.fill") // Or just "xmark"
                        .font(.title2)
                        .foregroundColor(.gray.opacity(0.6))
                        .padding(4)
                }
            }
            .padding(.bottom, 5) // Optional: space between header and stars
            
            // Star Rating Row
            HStack {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= rating ? "star.fill" : "star")
                        .foregroundColor(index <= rating ? .yellow : .gray.opacity(0.5))
                        .font(.title2)
                        .onTapGesture {
                            withAnimation(.spring()) { rating = index }
                        }
                }
            }
            
            // Feedback Text Area
            VStack(alignment: .leading) {
                Text("Share more details")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                TextEditor(text: $feedbackText)
                    .frame(height: 100)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            }
            
            // Submit Button
            Button(action: onSubmit) {
                Text("Submit Review")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        Group {
                            if rating == 0 {
                                Color.gray.opacity(0.3)
                            } else {
                                LinearGradient(
                                    gradient: Gradient(colors: [.appGreen, .secondGreen.opacity(0.8)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            }
                        }
                    )
                    .cornerRadius(10)
                // Add a subtle shadow only when active
                    .shadow(color: rating == 0 ? .clear : .lightAppGreen.opacity(0.3), radius: 5, x: 0, y: 3)
            }
            .disabled(rating == 0 || feedbackText.isEmpty)
            .padding(.horizontal, 40)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: rating)// Smooth color transition when rating changes // Prevent submission without a rating
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10)
    }
}


struct NoAccessView: View {
    var body: some View {
        VStack(spacing: 16) {
            // A soft icon that isn't too "aggressive"
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "lock.shield")
                    .font(.system(size: 32))
                    .foregroundColor(.gray)
            }
            
            VStack(spacing: 8) {
                //                Text("Review Unavailable")
                //                    .font(.headline)
                //                    .foregroundColor(.primary)
                
                Text("Only customers who have purchased this item can share their experience.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            
        }
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
    }
}
func avgRating(feedback: [Feedback]) -> Double {
    guard !feedback.isEmpty else { return 5.0 }
    let total = feedback.reduce(0.0) { $0 + (Double($1.productRating) ?? 0.0) }
    return total / Double(feedback.count)
}
