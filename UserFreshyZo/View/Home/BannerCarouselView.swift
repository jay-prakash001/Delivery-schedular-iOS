//
//  BannerCarouselView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 21/02/26.
//
import SwiftUI
import Combine




struct BannerCarouselView: View {
    let banners: [Banner]
    @EnvironmentObject var mainRouter: MainRouter
    
    @State private var currentIndex = 0
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        let bannerHeight: CGFloat = isPad ? 300 : 160
        
        // 1. Guard against empty data to avoid rendering an empty TabView
        if banners.isEmpty {
            Color.gray.opacity(0.1)
                .frame(height: bannerHeight)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        } else {
            TabView(selection: $currentIndex) {
                ForEach(Array(banners.enumerated()), id: \.offset) { index, banner in
                    AsyncImage(url: URL(string: banner.image)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: bannerHeight)
                                .clipped()
                        case .empty, .failure:
                            ZStack {
                                Color.gray.opacity(0.2)
                                ProgressView()
                            }
                            .frame(height: bannerHeight)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: isPad ? 18 : 12))
                    .contentShape(Rectangle())
                    .tag(index) // Important: links the enumerated index to $currentIndex
                    .onTapGesture {
                        handleNavigation(for: banner)
                    }
                }
            }
            .frame(height: bannerHeight)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .indexViewStyle(.page(backgroundDisplayMode: .never))
            // 2. CRITICAL: Force recreation of TabView when banners change.
            // This prevents "index out of bounds" crashes during data refresh.
            .id(banners.count)
            .onReceive(timer) { _ in
                let count = banners.count
                guard count > 1 else { return }
                
                withAnimation(.easeInOut) {
                    currentIndex = (currentIndex + 1) % count
                }
            }
            // 3. Fallback safety to ensure currentIndex is never invalid
            .onChange(of: banners) { newBanners in
                if currentIndex >= newBanners.count {
                    currentIndex = 0
                }
            }
        }
    }
    
    // Extracted navigation logic for cleanliness
    private func handleNavigation(for banner: Banner) {
        if banner.name.lowercased() == "referral" {
            mainRouter.navigate(to: .referandearn)
        } else {
            mainRouter.navigate(to: .milkbanneroffer(banner: banner))
        }
    }
}




struct BannerCarouselView0: View {
    
    let banners: [Banner]
    @EnvironmentObject var mainRouter : MainRouter
    
    @State private var currentIndex = 0
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        let bannerHeight: CGFloat = isPad ? 300 : 160
        
        TabView(selection: $currentIndex) {
            if !banners.isEmpty{
                
            
                ForEach(Array(banners.enumerated()), id: \.offset) { index, banner in
                    AsyncImage(url: URL(string: banner.image)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: bannerHeight)
                                .clipped()
                        case .empty, .failure:
                            Color.gray.opacity(0.2)
                                .frame(height: bannerHeight)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: isPad ? 18 : 12))
                    .contentShape(Rectangle()) // make entire tile tappable
                    
                    .buttonStyle(PlainButtonStyle())
                    .tag(index)
                }

            }
        }
        .frame(height: bannerHeight)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .indexViewStyle(.page(backgroundDisplayMode: .never))
        .onReceive(timer) { _ in
            let count = banners.count
            
            // 1. Guard against empty or single-item arrays
            guard count > 1 else { return }
            
            // 2. Calculate the next index safely
            let nextIndex = (currentIndex + 1) % count
            
            // 3. Final safety check: ensure the nextIndex is still within bounds
            // (in case the array shrunk during the logic execution)
            if nextIndex < count {
                withAnimation(.easeInOut) {
                    currentIndex = nextIndex
                }
            }
        }
        .onTapGesture {
            // Navigate from the page itself to avoid TabView gesture conflicts
//            
            if banners[currentIndex].name == "referral" {
                mainRouter.navigate(to: .referandearn)

            }else{
                mainRouter.navigate(to: .milkbanneroffer(banner: banners[currentIndex]))

            }
        }
        .onChange(of: banners.count) { newCount in
            // If the data changes and our current index is now invalid, snap to 0
            if currentIndex >= newCount {
                currentIndex = 0
            }
        }
    }
}

#Preview {
    NavigationStack {
        BannerCarouselView(banners: HomeViewModel().banners)
            .environmentObject(MainRouter()) // ensure router is injected
    }
}
