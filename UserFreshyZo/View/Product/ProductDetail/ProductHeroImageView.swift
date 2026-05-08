//
//  heroImageSection.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 30/03/26.
//

//  ProductHeroImageView.swift
//  UserFreshyZo

import SwiftUI
import AVKit
struct ProductHeroImageView: View {
    let productMediaUrls : [ProductAsset]
    let isPad: Bool
    let currentImageIndex: Int
    let onBack: () -> Void
    let onShare: () -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            TabView {
                ForEach(productMediaUrls) { item in
                    GeometryReader { proxy in
                        if item.isVideo, let url = URL(string: item.asset) {
                            
                            VideoPlayer(player: AVPlayer(url: url)) .frame(height: isPad ? 500 : 380)
//                            AutoPlayVideoView(url: url)
//                                .frame(height: isPad ? 500 : 380)
//                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        } else {
                            AsyncImage(url: URL(string: item.asset)) { phase in
                                
                                switch phase {
                                case .success(let image):
                                    image.resizable()
                                        .scaledToFill()
                                        .frame(width: proxy.size.width, height: proxy.size.height * 1.2)
                                        .clipped()
                                case .failure(let error):
                                    // Debug print to console to see why image fails
                                    let _ = print("Asset Error: \(error.localizedDescription)")
                                    Color.gray.opacity(0.1)
                                        .overlay(Image(systemName: "photo"))
                                default:
                                    ProgressView()
                                }
                            }.onAppear{
//                                print("media urls \(productMediaUrls)")
                            }
                        }
                    }
                }
            }
            .frame(height: isPad ? 500 : 400)
            .tabViewStyle(.page(indexDisplayMode: .always))
            .background(Color.black.opacity(0.05))
        
//            HStack {
//                Button(action: onBack) {
//                    Image(systemName: "arrow.left")
//                        .font(.system(size: 16, weight: .semibold))
//                        .foregroundColor(.black)
//                        .frame(width: 40, height: 40)
//                        .background(.white)
//                        .clipShape(Circle())
//                        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
//                }
//                Spacer()
//                Button(action: onShare) {
//                    Image(systemName: "square.and.arrow.up")
//                        .font(.system(size: 16, weight: .semibold))
//                        .foregroundColor(.black)
//                        .frame(width: 40, height: 40)
//                        .background(.white)
//                        .clipShape(Circle())
//                        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
//                }
//            }
//            .padding(.horizontal, 16)
//            .padding(.top, 56)
        }
        .frame(height: isPad ? 500 : 400)
    }
}

