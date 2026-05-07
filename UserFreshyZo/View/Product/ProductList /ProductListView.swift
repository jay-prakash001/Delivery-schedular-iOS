//
//  ProductListView.swift
//  UserFreshyZo
//

import SwiftUI

// MARK: - PreferenceKey
struct CategoryPositionKey: PreferenceKey {
    static var defaultValue: [String: CGFloat] = [:]
    static func reduce(value: inout [String: CGFloat], nextValue: () -> [String: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

// MARK: - ProductListView
struct ProductListView: View {

    @EnvironmentObject var vm: ProductViewModel

    // Scroll trigger — only set from tap, never from finger scroll
    @State private var tapScrollTarget: String? = nil

    // Timestamp of last tap — blocks preference updates during programmatic scroll
    @State private var lastTapTime: Date = .distantPast

    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        
        
        
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(vm.categoryOrder, id: \.self) { category in
                        if let products = vm.groupedProducts[category], !products.isEmpty {
                            CategorySectionView(
                                category: category,
                                products: products,
                                isPad: isPad
                            )
                        }
                    }
                    
                    Spacer().frame(height: 100)
                }
                .padding(.leading, 4)
                .padding(.trailing, 12)
                .padding(.top, isPad ? 20 : 12)
            }
            .coordinateSpace(name: "scroll")

            // ✅ PIPELINE 1: Tap → scroll
            // Watches tapScrollTarget ONLY — finger scrolling never triggers this
            .onChange(of: tapScrollTarget) { _, newTarget in
                guard let target = newTarget else { return }
                proxy.scrollTo(target, anchor: .top)
            }

            // ✅ PIPELINE 2: Finger scroll → sidebar highlight (instant, zero delay)
            // Never calls proxy.scrollTo — so zero lag possible
            .onPreferenceChange(CategoryPositionKey.self) { positions in

                // Hard wall: ignore all updates for 0.5s after a tap
                // Prevents preference updates during programmatic scroll
                guard Date().timeIntervalSince(lastTapTime) > 0.5 else { return }

                let threshold: CGFloat = 120
                let visible = positions
                    .filter { $0.value < threshold }
                    .max(by: { $0.value < $1.value })

                guard let matched = visible?.key else { return }
                guard vm.selectedCategoryId != matched else { return }

                vm.selectedCategoryId = matched
            }

            // ✅ Receives tap request from sidebar
            .onReceive(vm.$tapRequestedCategory) { category in
                guard let category else { return }
                lastTapTime = Date()           // start the 0.5s suppression window
                tapScrollTarget = category     // trigger scroll

                // Reset so same category can be tapped again
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    vm.tapRequestedCategory = nil
                    tapScrollTarget = nil
                }
            }
        }
        .onAppear {
//            vm.fetchProducts()
//            vm.fetchMockCategories()
        }
    }
}

// MARK: - Category Section
struct CategorySectionView: View {
    let category: String
    let products: [ProductFromApi]
    let isPad: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Invisible anchor — scroll target + position tracker
            Color.clear
                .frame(height: 1)
                .id(category)
                .background(
                    GeometryReader { geo in
                        Color.clear.preference(
                            key: CategoryPositionKey.self,
                            value: [category: geo.frame(in: .named("scroll")).minY]
                        )
                    }
                )

            

            ForEach(products, id: \.id) { product in
//                
                ProductCardView(product: product)
                    .padding(.bottom, isPad ? 20 : 16)
            }
            
            
            
        }
    }
}

