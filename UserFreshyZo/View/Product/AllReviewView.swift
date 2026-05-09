//
//  AllReviewView.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 09/05/26.
//

import SwiftUI

struct AllReviewView: View {
    @EnvironmentObject var mainRouter : MainRouter
    @EnvironmentObject var productViewModel : ProductViewModel
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad
    
    var body: some View {
        // 1. Add ScrollView to enable scrolling and top-alignment
        ScrollView {
            // 2. Set spacing to 0 or a specific value for consistent gaps
            VStack(alignment: .leading, spacing: 4) {
                if let productReview = productViewModel.selectedProductData?.review.feedbacks, !productReview.isEmpty {
                    ForEach(productReview) { feedbackItem in
                        ReviewCardListItem(isPad: isPad, feedback: feedbackItem)
                    }
                } else {
                    // 3. Center the empty state message
                    VStack {
                        Spacer(minLength: 50)
                        Text("No Product Review Available")
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(10)
        }
        .navigationTitle("Product Rating & Review")
        // 4. Set the display mode to inline if you want a smaller title
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AllReviewView()
}
