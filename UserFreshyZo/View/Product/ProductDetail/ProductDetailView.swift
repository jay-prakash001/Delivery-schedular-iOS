//  ProductDetailModels.swift
//  UserFreshyZo

//  ProductDetailView.swift
//  UserFreshyZo

import SwiftUI

struct ProductDetailView: View {

    let product: Product
    @EnvironmentObject var cartVM: CartViewModel
    @Environment(\.dismiss) var dismiss

    @State private var expandedFAQID: UUID? = nil
    @State private var subscriptionQty: Int = 2
    @State private var currentImageIndex: Int = 0
    @State private var showShareSheet = false
    @State private var showSubscription = false


    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    private var fullProductTitle: String {
        let name = product.cleanName.replacingOccurrences(of: "\n", with: "")
        let unit = product.quantityText
        return unit.isEmpty ? name : "\(name) \(unit)"
    }

    private var shareText: String {
        "Check out FreshyZo \(fullProductTitle) at ₹\(product.price)! Farm-fresh A2 Gir Cow milk delivered to your door. #FreshyZo"
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 0) {
                    ProductHeroImageView(
                        product: product,
                        isPad: isPad,
                        currentImageIndex: currentImageIndex,
                        onBack: { dismiss() },
                        onShare: { showShareSheet = true }
                    )

                    ProductInfoCardView(product: product, isPad: isPad, subscriptionQty: $subscriptionQty)
                        .padding(.horizontal, isPad ? 24 : 16).padding(.top, 16)

                    ProductNutritionCardView(isPad: isPad)
                        .padding(.horizontal, isPad ? 24 : 16).padding(.top, 14)

                    ProductDescriptionCardView(product: product, isPad: isPad)  
                        .padding(.horizontal, isPad ? 24 : 16).padding(.top, 14)
                    
                    ProductComparisonCardView(isPad: isPad)
                        .padding(.horizontal, isPad ? 24 : 16).padding(.top, 14)

                    ProductRatingsCardView(isPad: isPad)
                        .padding(.horizontal, isPad ? 24 : 16).padding(.top, 14)

                    ProductWhyChooseCardView(isPad: isPad)
                        .padding(.horizontal, isPad ? 24 : 16).padding(.top, 14)

                    ProductFAQCardView(
                        faqItems: FAQProvider.faqItems(for: product.cleanCategory),
                        isPad: isPad,
                        expandedFAQID: $expandedFAQID
                    )
                    .padding(.horizontal, isPad ? 24 : 16).padding(.top, 14)

                    Spacer().frame(height: 100)
                }
            }
            .background(Color(UIColor.systemGroupedBackground))

            ProductStickyBottomView(
                isPad: isPad,
                subscriptionQty: subscriptionQty,
                onContinue: {
                    showSubscription = true
                    // Pass subscriptionQty to your subscription flow here
                }
            )
            .navigationDestination(isPresented: $showSubscription) {
                SubscriptionView(product: product, initialQty: subscriptionQty)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarHidden(true)
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [shareText])
        }
    }
}
