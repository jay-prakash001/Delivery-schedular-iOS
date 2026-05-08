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
    private let overlapOffset: CGFloat = 30

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
        GeometryReader { rootProxy in
            let heroHeight = rootProxy.size.height * 0.6

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
                                            return []
                                        }()
                                    ProductHeroImageView(
                                        productMediaUrls: mediaUrls,
                                        isPad: isPad,
                                        currentImageIndex: currentImageIndex,
                                        onBack: { dismiss() },
                                        onShare: { showShareSheet = true }
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
                                        feedBacks: detailContainer?.review.feedbacks ?? []
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
                        ProductStickyBottomView(
                            isPad: isPad,
                            subscriptionQty: subscriptionQty,
                            onContinue: {
                                mainRouter.navigate(to: .subscriptionstart(product: product, quantity: subscriptionQty))
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
    }
}// Preference Key for tracking scroll
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ProductDetailView0: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    @EnvironmentObject var mainRouter : MainRouter
    @EnvironmentObject var cartViewModel : CartViewModel
    @Environment(\.dismiss) var dismiss
    var id: String
    @State private var showSolidNavbar = false
    // Waterfall data source
//    var displayProduct: ProductFromApi? {
//        productViewModel.selectedProductData?.productDetails.first(where: { $0.productId == id }) ??
//        productViewModel.productData?.productList.first(where: { $0.productId == id })
//    }
//
    var displayProduct: ProductFromApi? {
        // 1. Identify our two sources
        // 'detailed' comes from the Detail API, 'listItem' comes from the List/Home API
        let detailed = productViewModel.selectedProductData?.productDetails.first(where: { $0.productId == id })
        let listItem = productViewModel.productData?.productList.first(where: { $0.productId == id })
        
        // 2. Set 'detailed' as the priority. If it's nil, fall back to 'listItem'.
        // If neither exists, we can't show the screen.
        guard var product = detailed ?? listItem else { return nil }

        // --- 1. ASSETS FALLBACK ---
        // If the product has no images/videos in its assets array
        let isAssetsEmpty = product.productAssets.isEmpty || product.productAssets.first?.asset.trimmingCharacters(in: .whitespaces).isEmpty == true
        
        if isAssetsEmpty {
            // Priority 1: Check if the global detail container has shared assets
            if let globalAssets = productViewModel.selectedProductData?.productAssets, !globalAssets.isEmpty {
                product.productAssets = globalAssets
            }
            // Priority 2: Use the single image URL from the list item
            else if let fallbackUrl = listItem?.dairyProductImage, !fallbackUrl.isEmpty {
                product.productAssets = [ProductAsset(asset: fallbackUrl)]
            }
            // Priority 3: Use the single image URL from the detailed object itself
            else if !product.dairyProductImage.isEmpty {
                product.productAssets = [ProductAsset(asset: product.dairyProductImage)]
            }
        }

        // --- 2. FAQ FALLBACK ---
        // If the specific product has no FAQs, check the global FAQ list for this category
        if product.productFaq.isEmpty {
            product.productFaq = productViewModel.selectedProductData?.productFaq ?? []
        }
        
        

        // --- 3. DESCRIPTION FALLBACK ---
        // If the detailed description is missing, use the short description from the list
        if product.description.isEmpty {
            // Since listItem.shortDesc is guaranteed by your model, this is safe
            product.description = listItem?.shortDesc ?? ""
        }

        
        
        return product
    }



    @State private var expandedFAQID: UUID? = nil

    @State private var subscriptionQty: Int = 0
    @State private var currentImageIndex: Int = 0
    @State private var showShareSheet = false
    @State private var showSubscription = false
    
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    private let overlapOffset: CGFloat = 30
    private var shareText: String {
        guard let product = displayProduct else { return "FreshyZo Milk" }
        
        // Use 'product' directly since it's already unwrapped
        let name = product.productName ?? "FreshyZo Milk"
        let price = product.productPrice ?? "--"
        
        return "Check out FreshyZo \(name) at ₹\(price)! Farm-fresh products delivered to your door. #FreshyZo"
    }

    var body: some View {
        GeometryReader { rootProxy in
            // Derive hero height from the current container, not UIScreen.main
            let heroHeight = rootProxy.size.height * 0.56

            ZStack(alignment: .top) {
                // 1. MAIN SCROLLVIEW
                VStack{
                    
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            
                            // 2. PARALLAX IMAGE SECTION
                            GeometryReader { geo in
                                let minY = geo.frame(in: .global).minY
                                
                                
                                if let product = displayProduct {
                                    let mediaUrls = (product.productAssets.isEmpty == false)
                                    ? product.productAssets
                                    : [ProductAsset(asset: "00")]
                                    
                                    ProductHeroImageView(
                                        productMediaUrls: mediaUrls,
                                        isPad: false,
                                        currentImageIndex: 0,
                                        onBack: { dismiss() },
                                        onShare: { }
                                    )
                                    
                                    
                                    
                                    .frame(width: geo.size.width, height: heroHeight + (minY > 0 ? minY : 0))
                                    /*
                                     The Magic:
                                     When minY < 0 (scrolling up), we offset the image by HALF that amount.
                                     This makes it scroll at 0.5x speed.
                                     */
                                    .offset(y: minY > 0 ? -minY : -minY * 0.5)
                                }
                            }
                            .frame(height: heroHeight)
                            .zIndex(0)
                            
                            // 3. CONTENT CARD
                            VStack(spacing: 6) {
                                
                                
                                if let product = displayProduct {
                                    ProductInfoCardView(product: product, isPad: isPad, subscriptionQty: $subscriptionQty)
                                        .padding(.horizontal, isPad ? 24 : 12)
                                    
                                    //                                ProductNutritionCardView(isPad: isPad)
                                    //                                    .padding(.horizontal, isPad ? 24 : 16)
                                    
                                    
//                                    if let description = product.description, !description.isEmpty {
                                        
                                        
                                        

                                    ProductDescriptionCardView(productDesc: product.description ?? "",tags : product.tags, isPad: isPad)
                                            .padding(.horizontal, isPad ? 24 : 12)
                                        
//                                    }
                                    
                                    ProductComparisonCardView(isPad: isPad)
                                        .padding(.horizontal, isPad ? 24 : 12)
                                    
                                    Text("\(product.review?.feedbacks ?? [])")
                                    ProductRatingsCardView(isPad: isPad, feedBacks: product.review?.feedbacks ?? [])
                                        .padding(.horizontal, isPad ? 24 : 12)
                                    
                                    ProductWhyChooseCardView(isPad: isPad)
                                        .padding(.horizontal, isPad ? 24 : 12)
                                    
                                    
                                    ProductFAQCardView(
                                        faqItems: product.productFaq ?? [],
                                        isPad: isPad,
                                        expandedFAQID: $expandedFAQID
                                    )
                                    .padding(.horizontal, isPad ? 24 : 12)
                                    
                                    Spacer().frame(height: 120)
                                    
                                }
                            }
                            .padding(6)
                            .background(Color(.white))
                            .cornerRadius(30, corners: [.topLeft, .topRight])
                            /*
                             Offset the card upward so it starts overlapping
                             the image before the user even scrolls.
                             */
                            .offset(y: -overlapOffset)
                            .zIndex(1) // Ensures card stays on top of image
                        }
                        
                    }
                    
                    
                    ProductStickyBottomView(
                        isPad: isPad,
                        subscriptionQty: subscriptionQty,
                        onContinue: {
                            
                            mainRouter.navigate(to: .subscriptionstart(product: displayProduct!, quantity: subscriptionQty ))
//                            showSubscription = true
                        }
                    )
                }
                // 4. FLOATING NAVIGATION BAR
                // Using ZStack top alignment to keep buttons fixed while content scrolls underneath
//                customNavigationBar
                
                
            }
            
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: [shareText])
            }
            
//            .padding(.top, safeAreaTop)

//            .ignoresSafeArea(edges: .top)
            .navigationBarHidden(false)
        }
        .onAppear {
            // Safe to access EnvironmentObjects and self.id here
            subscriptionQty = cartViewModel.getQuantityByProductId(id)
        }
        .onChange(of: id) { _, newValue in
            subscriptionQty = cartViewModel.getQuantityByProductId(newValue)
        }
    }

    private var customNavigationBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                    .padding(12)
                    // If navbar is solid, we remove the individual button blur
                    .background(.ultraThinMaterial.opacity(showSolidNavbar ? 0 : 1))
                    .clipShape(Circle())
            }
            
            if showSolidNavbar {
                Text(displayProduct?.productName ?? "")
                    .font(.headline)
                    .lineLimit(1)
                    .transition(.opacity) // Smooth fade in for the title
            }
            
            Spacer()
            
            Button(action: { /* Share */ }) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 18, weight: .bold))
                    .padding(12)
                    .background {
                        if !showSolidNavbar {
                            Circle().fill(.ultraThinMaterial)
                        }
                    }
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal)
//        .padding(.top, safeAreaTop)
        .padding(.bottom, 10)
        .foregroundColor(.primary)
        // THE DYNAMIC BACKGROUND
        .background(
            Group {
                if showSolidNavbar {
                    Color.white
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                } else {
                    Color.clear
                }
            }
        )
        .animation(.default, value: showSolidNavbar)
    }

    private var safeAreaTop: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        return windowScene?.windows.first?.safeAreaInsets.top ?? 0
    }
}


