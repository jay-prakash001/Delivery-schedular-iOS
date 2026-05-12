////  ProductDetailModels.swift
////  UserFreshyZo
//
////  ProductDetailView.swift
////  UserFreshyZo
//
//import SwiftUI
//



import SwiftUI
import UIKit





struct ProductDetailView: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    @EnvironmentObject var mainRouter: MainRouter
    @EnvironmentObject var cartViewModel: CartViewModel
    @Environment(\.dismiss) var dismiss
    
    var id: String
    
    @State private var showSolidNavbar = false
    @State private var expandedFAQID: UUID? = nil
    @State private var subscriptionQty: Int = 0
    @State private var currentImageIndex: Int = 0
    @State private var showShareSheet = false
    
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad
    private let overlapOffset: CGFloat = 60
    
    // MARK: - Computed Observation Logic
    
    /// This returns the FULL detail container from the API response
    var detailContainer: ProductDetailData? {
        productViewModel.selectedProductData
    }
    
    /// This returns the specific product info (Priority: Detail API -> List Fallback)
    var displayProduct: ProductFromApi? {
        if let detailed = detailContainer?.productDetails.first(where: { $0.productId == id }) {
            return detailed
        }
        return productViewModel.productData?.productList.first(where: { $0.productId == id })
    }
    
    var body: some View {
        
        ZStack(alignment: .bottom){
            GeometryReader { rootProxy in
                let heroHeight = rootProxy.size.height * 0.56
                
                ZStack(alignment: .top) {
                    VStack(spacing: 0) {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 0) {
                                
                                // 1. HERO IMAGE SECTION
                                GeometryReader { geo in
                                    let minY = geo.frame(in: .global).minY
                                    
                                    if let product = displayProduct {
                                        // Use Assets from the container, fallback to product image
                                        let mediaUrls: [ProductAsset] = {
                                            // 1. Check if the high-quality assets gallery exists in the Detail Container
                                            if let detailAssets = detailContainer?.productAssets, !detailAssets.isEmpty {
                                                return detailAssets
                                            }
                                            
                                            // 2. Check if the detailed product info has a specific image
                                            if !product.dairyProductImage.isEmpty {
                                                return [ProductAsset(asset: product.dairyProductImage)]
                                            }
                                            
                                            // 3. ULTIMATE FALLBACK: Get the image from the LIST object
                                            // We find the same product ID in the main list to grab its 'dairyProductImage'
                                            if let listItem = productViewModel.productData?.productList.first(where: { $0.productId == id }),
                                               !listItem.dairyProductImage.isEmpty {
                                                return [ProductAsset(asset: listItem.dairyProductImage)]
                                            }
                                            
                                            // 4. Final safety net: Return an empty array or a placeholder image asset
                                            return [ProductAsset(asset: "https://freshyzo.com/wp-content/uploads/2024/06/WhatsApp-Image-2024-06-05-at-5.15.56-PM-e1717648546412.jpeg")]
                                        }()
                                        ProductHeroImageView(
                                            productMediaUrls: mediaUrls,
                                            isPad: isPad,
                                            currentImageIndex: currentImageIndex,
                                            onBack: { dismiss() },
                                            onShare: {
                                                
//                                                showShareSheet = true
                                                
                                                // 1. Construct the formatted message
                                                let shareMessage = """
                                                🛒 Check out this product on Freshyzo!

                                                Product : \(displayProduct?.productName ?? "FreshyZo Milk")
                                                Price   : ₹\(displayProduct?.mrp ?? "0")

                                                \(displayProduct?.description.prefix(100) ?? "Wholesome, calcium-rich, pure.")

                                                Download Freshyzo App: https://play.google.com/store/search?q=freshyzo&c=apps&hl=en_IN
                                                """

                                                // 2. Call your function with the new message
                                                shareProductContent(
                                                    text: shareMessage,
                                                    link: "https://freshyzo.com",
                                                    imageUrl: mediaUrls.first?.asset ?? "https://freshyzo.com/wp-content/uploads/2024/06/WhatsApp-Image-2024-06-05-at-5.15.56-PM-e1717648546412.jpeg"
                                                )
                                                
                                                
                                            }
                                        )
                                        .frame(width: geo.size.width, height: heroHeight + (minY > 0 ? minY : 0))
                                        .offset(y: minY > 0 ? -minY : -minY * 0.5)
                                    }
                                }
                                .frame(height: heroHeight)
                                .zIndex(0)
                                
                                // 2. CONTENT CARD
                                VStack(spacing: 12) {
                                    if let product = displayProduct {
                                        ProductInfoCardView(product: product, isPad: isPad, subscriptionQty: $subscriptionQty)
                                            .padding(.horizontal, isPad ? 24 : 12)
                                        
                                        ProductDescriptionCardView(productDesc: product.description, tags: product.tags, isPad: isPad)
                                            .padding(.horizontal, isPad ? 24 : 12)
                                        
                                        ProductComparisonCardView(isPad: isPad)
                                            .padding(.horizontal, isPad ? 24 : 12)
                                        
                                        // REVIEWS: Pulling from detailContainer
                                        ProductRatingsCardView(
                                            isPad: isPad,
                                            feedBacks: detailContainer?.review.feedbacks ?? [],
                                            canWriteFeedBack: detailContainer?.review.writeReview ?? false
                                        )
                                        .padding(.horizontal, isPad ? 24 : 12)
                                        
                                        ProductWhyChooseCardView(isPad: isPad)
                                            .padding(.horizontal, isPad ? 24 : 12)
                                        
                                        // FAQs: Pulling from detailContainer
                                        ProductFAQCardView(
                                            faqItems: detailContainer?.productFaq ?? [],
                                            isPad: isPad,
                                            expandedFAQID: $expandedFAQID
                                        )
                                        .padding(.horizontal, isPad ? 24 : 12)
                                        
                                        Spacer().frame(height: 120)
                                    }
                                }
                                .padding(.top, 20)
                                .background(Color.white)
                                .cornerRadius(30, corners: [.topLeft, .topRight])
                                .offset(y: -overlapOffset)
                                .zIndex(1)
                            }
                        }
                        
                        // 3. STICKY BOTTOM
                        if let product = displayProduct {
                            
                            
                            let mediaUrls: [ProductAsset] = {
                                // 1. Check if the high-quality assets gallery exists in the Detail Container
                                if let detailAssets = detailContainer?.productAssets, !detailAssets.isEmpty {
                                    return detailAssets
                                }
                                
                                // 2. Check if the detailed product info has a specific image
                                if !product.dairyProductImage.isEmpty {
                                    return [ProductAsset(asset: product.dairyProductImage)]
                                }
                                
                                // 3. ULTIMATE FALLBACK: Get the image from the LIST object
                                // We find the same product ID in the main list to grab its 'dairyProductImage'
                                if let listItem = productViewModel.productData?.productList.first(where: { $0.productId == id }),
                                   !listItem.dairyProductImage.isEmpty {
                                    return [ProductAsset(asset: listItem.dairyProductImage)]
                                }
                                
                                // 4. Final safety net: Return an empty array or a placeholder image asset
                                return [ProductAsset(asset: "https://freshyzo.com/wp-content/uploads/2024/06/WhatsApp-Image-2024-06-05-at-5.15.56-PM-e1717648546412.jpeg")]
                            }()
                            ProductStickyBottomView(
                                isPad: isPad,
                                subscriptionQty: subscriptionQty,
                                onContinue: {
                                    mainRouter.navigate(to: .subscriptionstart(product: product, mediaUrls: mediaUrls, quantity: subscriptionQty))
                                }
                            )
                            .background(Color.white)
                        }
                    }
                    
                    
                    
                }
                
            }
            .onAppear {
                subscriptionQty = cartViewModel.getQuantityByProductId(id)
                productViewModel.fetchProductDetailsById(id)
            }
            
            if let reviewSubmitState = productViewModel.ratingResponse{
                
                HStack(alignment : .bottom){
                    VStack{
                        Spacer()
                        ToastView(message: reviewSubmitState.message)

                    }
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity).onAppear{
                    print("review response in screen")
                    
                }
            }
            
            
            if showShareSheet {
                ShareSheet(activityItems: ["hello"])
            }
            
            
        }
    }
}// Preference Key for tracking scroll
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}




