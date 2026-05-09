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
    @EnvironmentObject var mainRouter : MainRouter
    
    @State private var currentIndex = 0
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        let bannerHeight: CGFloat = isPad ? 300 : 160
        
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
        .onTapGesture {
            // Navigate from the page itself to avoid TabView gesture conflicts
            
            if banners[currentIndex].name == "referral" {
                mainRouter.navigate(to: .referandearn)

            }else{
                mainRouter.navigate(to: .milkbanneroffer(banner: banners[currentIndex]))

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
