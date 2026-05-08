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
        let detailed = productViewModel.selectedProductData?.productDetails.first(where: { $0.productId == id })
        let listItem = productViewModel.productData?.productList.first(where: { $0.productId == id })
        
        // 2. Set 'detailed' as the priority. If it's nil, fall back to 'listItem'.
        guard var product = detailed ?? listItem else { return nil }

        // --- 1. ASSETS FALLBACK ---
        // Check if the current product has valid assets
        let currentAssets = product.productAssets ?? []
        let isAssetsEmpty = currentAssets.isEmpty || (currentAssets.first?.asset.trimmingCharacters(in: .whitespaces).isEmpty ?? true)

        if isAssetsEmpty {
            // Priority 1: Check if the global view model has a general asset list
            if let globalAssets = productViewModel.selectedProductData?.productAssets, !globalAssets.isEmpty {
                product.productAssets = globalAssets
            }
            // Priority 2: Check if listItem has a specific image URL
            else if let fallbackUrl = listItem?.dairyProductImage, !fallbackUrl.isEmpty {
                product.productAssets = [ProductAsset(asset: fallbackUrl)]
            }
            // Priority 3: Check if current product (even if detailed) has a single image
            else if let selfUrl = product.dairyProductImage, !selfUrl.isEmpty {
                product.productAssets = [ProductAsset(asset: selfUrl)]
            }
        }

        // --- 2. FAQ FALLBACK ---
        if product.productFaq == nil || (product.productFaq?.isEmpty ?? true) {
            // Try to get FAQs from the view model container
            product.productFaq = productViewModel.selectedProductData?.productFaq
        }

        // --- 3. DESCRIPTION FALLBACK ---
        if product.description == nil || (product.description?.isEmpty ?? true) {
            // Use the short description from the list item as a backup
            product.description = listItem?.shortDesc
        }

        return product
    }



    @State private var expandedFAQID: UUID? = nil

    @State private var subscriptionQty: Int = 2
    @State private var currentImageIndex: Int = 0
    @State private var showShareSheet = false
    @State private var showSubscription = false
    
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    private let overlapOffset: CGFloat = 30
    
    var body: some View {
        GeometryReader { rootProxy in
            // Derive hero height from the current container, not UIScreen.main
            let heroHeight = rootProxy.size.height * 0.6

            ZStack(alignment: .top) {
                // 1. MAIN SCROLLVIEW
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        
                        // 2. PARALLAX IMAGE SECTION
                        GeometryReader { geo in
                            let minY = geo.frame(in: .global).minY
                            

                            if let product = displayProduct {
                                let mediaUrls = (product.productAssets?.isEmpty == false)
                                                    ? product.productAssets!
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
                        VStack(spacing: 20) {
                            
                            
                            if let product = displayProduct {
                                ProductInfoCardView(product: product, isPad: isPad, subscriptionQty: $subscriptionQty)
                                    .padding(.horizontal, isPad ? 24 : 12)
                                
                                //                                ProductNutritionCardView(isPad: isPad)
                                //                                    .padding(.horizontal, isPad ? 24 : 16)
                                
                                ProductDescriptionCardView(product: product, isPad: isPad)
                                    .padding(.horizontal, isPad ? 24 : 12)
                                
                                ProductComparisonCardView(isPad: isPad)
                                    .padding(.horizontal, isPad ? 24 : 12)
                                
                                ProductRatingsCardView(isPad: isPad)
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
                        .padding(.horizontal)
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

                // 4. FLOATING NAVIGATION BAR
                // Using ZStack top alignment to keep buttons fixed while content scrolls underneath
//                customNavigationBar
            }
//            .padding(.top, safeAreaTop)

//            .ignoresSafeArea(edges: .top)
            .navigationBarHidden(false)
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


struct ProductDetailView0: View {
    // MARK: - Properties
    @EnvironmentObject var productViewModel: ProductViewModel
    @EnvironmentObject var cartVM: CartViewModel
    @Environment(\.dismiss) var dismiss
    
    var id: String

    // Computed property to find the specific product
    var product: ProductFromApi? {
        productViewModel.productData?.productList.first(where: { $0.productId == id })
    }
    
    var productData: ProductDetailData? {
            productViewModel.selectedProductData
        }
    
    
    var displayProduct: ProductFromApi? {
        // 1. Try to get the detailed product from the Detail API source
        if let detailedProduct = productViewModel.selectedProductData?.productDetails.first(where: { $0.productId == id }) {
            return detailedProduct
        }
        
        // 2. Fallback: Get the basic product from the List API source
        return productViewModel.productData?.productList.first(where: { $0.productId == id })
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
        guard let product = displayProduct else { return "Product" }
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
                            ProductHeroImageView(productMediaUrls: (productViewModel.selectedProductData?.productAssets.isEmpty == false)
                                                 ? productViewModel.selectedProductData!.productAssets
                                                 : [ProductAsset(asset: product.dairyProductImage ?? "")],
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
                                faqItems: productData?.productFaq ?? [],
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
//        .ignoresSafeArea(edges: .top)
//        .navigationBarHidden(true)
    }
}
