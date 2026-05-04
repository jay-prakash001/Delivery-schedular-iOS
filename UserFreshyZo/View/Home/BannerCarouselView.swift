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
    
    @State private var currentIndex = 0
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        let bannerHeight: CGFloat = isPad ? 300 : 180
        TabView(selection: $currentIndex) {
            
            
            ForEach(Array(banners.enumerated()), id: \.element.id) { index, banner in
                
                // ✅ ONLY CHANGE: wrapped AsyncImage inside NavigationLink
                NavigationLink(destination: MilkTrialView(banner: banner)) {
                    
                    AsyncImage(url: URL(string: banner.image)) { phase in
                        switch phase {
                            
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: bannerHeight)
                                .clipped()
                            
                        case .empty:
                            Color.gray.opacity(0.2)
                                .frame(height: bannerHeight)
                            
                        case .failure:
                            Color.gray.opacity(0.2)
                                .frame(height: bannerHeight)
                            
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: isPad ? 18 : 12))
                }
                .buttonStyle(PlainButtonStyle()) // ← prevents blue tint on tap
                .tag(index)
            }
        }
        .frame(height: bannerHeight)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .indexViewStyle(.page(backgroundDisplayMode: .never))
        .onReceive(timer) { _ in
            guard !banners.isEmpty else { return }
            withAnimation {
                currentIndex = (currentIndex + 1) % banners.count
            }
        }
    }
}

#Preview {
    NavigationStack {
        BannerCarouselView(banners: HomeViewModel().banners)
    }
}
