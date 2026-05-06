////  ProductDetailModels.swift
////  UserFreshyZo
//
////  ProductDetailView.swift
////  UserFreshyZo
//
//import SwiftUI
//



import SwiftUI

struct ProductDetailView: View {
    // MARK: - Properties
    @EnvironmentObject var productViewModel: ProductViewModel
    @EnvironmentObject var cartVM: CartViewModel
    @Environment(\.dismiss) var dismiss
    
    var id: String

    // Computed property to find the specific product
    var product: ProductFromApi? {
        productViewModel.productData?.productList.first(where: { $0.productId == id })
    }
    
    @State private var expandedFAQID: UUID? = nil
    @State private var subscriptionQty: Int = 2
    @State private var currentImageIndex: Int = 0
    @State private var showShareSheet = false
    @State private var showSubscription = false

    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    // MARK: - Safe Computed Properties
    // We use guard to handle the nil case so the app doesn't crash
    private var fullProductTitle: String {
        guard let product = product else { return "Product" }
        let name = product.productName.replacingOccurrences(of: "\n", with: "")
        let unit = product.unit
        return unit.isEmpty ? name : "\(name) \(unit)"
    }

    private var shareText: String {
        guard let product = product else { return "" }
        return "Check out FreshyZo \(fullProductTitle) at ₹\(product.productPrice)! Farm-fresh products delivered to your door. #FreshyZo"
    }

    // MARK: - Body
    var body: some View {
        Group {
            if let product = product {
                // Main Content when product is found
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
                                .padding(.horizontal, isPad ? 24 : 16)
                                .padding(.top, 16)

                            ProductNutritionCardView(isPad: isPad)
                                .padding(.horizontal, isPad ? 24 : 16)
                                .padding(.top, 14)

                            ProductDescriptionCardView(product: product, isPad: isPad)
                                .padding(.horizontal, isPad ? 24 : 16)
                                .padding(.top, 14)
                            
                            ProductComparisonCardView(isPad: isPad)
                                .padding(.horizontal, isPad ? 24 : 16)
                                .padding(.top, 14)

                            ProductRatingsCardView(isPad: isPad)
                                .padding(.horizontal, isPad ? 24 : 16)
                                .padding(.top, 14)

                            ProductWhyChooseCardView(isPad: isPad)
                                .padding(.horizontal, isPad ? 24 : 16)
                                .padding(.top, 14)

                            ProductFAQCardView(
                                faqItems: FAQProvider.faqItems(for: product.productSubCategoryName),
                                isPad: isPad,
                                expandedFAQID: $expandedFAQID
                            )
                            .padding(.horizontal, isPad ? 24 : 16)
                            .padding(.top, 14)

                            Spacer().frame(height: 120) // Extra space for sticky bottom
                        }
                    }
                    .background(Color(UIColor.systemGroupedBackground))

                    // Sticky Bottom Bar
                    ProductStickyBottomView(
                        isPad: isPad,
                        subscriptionQty: subscriptionQty,
                        onContinue: {
                            showSubscription = true
                        }
                    )
                }
                .sheet(isPresented: $showShareSheet) {
                    ShareSheet(activityItems: [shareText])
                }
            } else {
                // Loading State
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Loading product...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarHidden(true)
    }
}
//struct ProductDetailView: View {
//    @EnvironmentObject var productViewModel : ProductViewModel
//    var id: String
//
//    var product: Product? {
//        productViewModel.productData?.productList.first(where: { $0.productId == id })
//    }
//    
//    
//    
//    @EnvironmentObject var cartVM: CartViewModel
//    @Environment(\.dismiss) var dismiss
//
//    @State private var expandedFAQID: UUID? = nil
//    @State private var subscriptionQty: Int = 2
//    @State private var currentImageIndex: Int = 0
//    @State private var showShareSheet = false
//    @State private var showSubscription = false
//
//
//    private let isPad = UIDevice.current.userInterfaceIdiom == .pad
//
//    private var fullProductTitle: String {
//        let name = product.cleanName.replacingOccurrences(of: "\n", with: "")
//        let unit = product.quantityText
//        return unit.isEmpty ? name : "\(name) \(unit)"
//    }
//
//    private var shareText: String {
//        "Check out FreshyZo \(fullProductTitle) at ₹\(product.price)! Farm-fresh A2 Gir Cow milk delivered to your door. #FreshyZo"
//    }
//
//    var body: some View {
//        
//        if let product = product{
//            
//            ZStack(alignment: .bottom) {
//                ScrollView {
//                    VStack(spacing: 0) {
//                        ProductHeroImageView(
//                            product: product,
//                            isPad: isPad,
//                            currentImageIndex: currentImageIndex,
//                            onBack: { dismiss() },
//                            onShare: { showShareSheet = true }
//                        )
//
//                        ProductInfoCardView(product: product, isPad: isPad, subscriptionQty: $subscriptionQty)
//                            .padding(.horizontal, isPad ? 24 : 16).padding(.top, 16)
//
//                        ProductNutritionCardView(isPad: isPad)
//                            .padding(.horizontal, isPad ? 24 : 16).padding(.top, 14)
//
//                        ProductDescriptionCardView(product: product, isPad: isPad)
//                            .padding(.horizontal, isPad ? 24 : 16).padding(.top, 14)
//                        
//                        ProductComparisonCardView(isPad: isPad)
//                            .padding(.horizontal, isPad ? 24 : 16).padding(.top, 14)
//
//                        ProductRatingsCardView(isPad: isPad)
//                            .padding(.horizontal, isPad ? 24 : 16).padding(.top, 14)
//
//                        ProductWhyChooseCardView(isPad: isPad)
//                            .padding(.horizontal, isPad ? 24 : 16).padding(.top, 14)
//
//                        ProductFAQCardView(
//                            faqItems: FAQProvider.faqItems(for: product.cleanCategory),
//                            isPad: isPad,
//                            expandedFAQID: $expandedFAQID
//                        )
//                        .padding(.horizontal, isPad ? 24 : 16).padding(.top, 14)
//
//                        Spacer().frame(height: 100)
//                    }
//                }
//                .background(Color(UIColor.systemGroupedBackground))
//
//                ProductStickyBottomView(
//                    isPad: isPad,
//                    subscriptionQty: subscriptionQty,
//                    onContinue: {
//                        showSubscription = true
//                        // Pass subscriptionQty to your subscription flow here
//                    }
//                )
//                .navigationDestination(isPresented: $showSubscription) {
//                    SubscriptionView(product: product, initialQty: subscriptionQty)
//                }
//            }
//            .ignoresSafeArea(edges: .top)
//            .navigationBarHidden(true)
//            .sheet(isPresented: $showShareSheet) {
//                ShareSheet(activityItems: [shareText])
//            }
//        }else{
//            ProgressView("Loading product...")
//                        .navigationBarHidden(false)
//        }
//    }
//}
//
