//
//  ArticleView.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 11/05/26.
//

import SwiftUI

struct ArticleView: View {
    var article : HomeBlogs
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad
    @Environment(\.dismiss) var dismiss
    private let overlapOffset: CGFloat = 60
    
    var body: some View {
        ZStack(alignment: .bottom){
            
            GeometryReader { rootProxy in
                let heroHeight = rootProxy.size.height * 0.38
                ScrollView(showsIndicators: false) {
                    
                    VStack{
                        
                        VStack( spacing: 12){
                            GeometryReader { geo in
                                let minY = geo.frame(in: .global).minY
                                
                                let mediaUrls = [ProductAsset(asset: article.imageUrl)]
                                
                                ZStack{
                                    ProductHeroImageView(
                                        productMediaUrls: mediaUrls,
                                        isPad: isPad,
                                        currentImageIndex: 0,
                                        onBack: { dismiss() },
                                        onShare: {
                                            
                                            //                                                showShareSheet = true
                                            
                                            // 1. Construct the formatted message
                                            let shareMessage = """
                                📖 Read this interesting blog on Freshyzo!
                                
                                Why Freshyzo
                                
                                Health and wellness focus on maintaining a balanced lifestyle through proper nutrition, regular exercise, and mental well-being to improve overall quality of life.
                                
                                Download Freshyzo App: https://play.google.com/store/apps/details?id=com.shyamdairyfarm.user
                                """
                                            
                                            // 2. Call your function with the new message
                                            shareProductContent(
                                                text: shareMessage,
                                                link: "https://freshyzo.com",
                                                imageUrl: mediaUrls.first?.asset ?? "https://freshyzo.com/wp-content/uploads/2024/06/WhatsApp-Image-2024-06-05-at-5.15.56-PM-e1717648546412.jpeg"
                                            )
                                            
                                            
                                        }
                                    )
                                    VStack(alignment: .trailing) {
                                        Spacer()
                                        VStack(spacing: 10){
                                            Text("HEALTH AND WELLNESS")
                                                .font(.subheadline)
                                                .bold()
                                                .foregroundColor(.white)
                                                .padding(.vertical, 6)   // Vertical spacing inside the bubble
                                                .padding(.horizontal, 10) // Horizontal spacing inside the bubble
                                                .background(Color.lightAppGreen.opacity(0.4))
                                                .cornerRadius(20)
                                            
                                            Text(article.title.capitalized).font(.title).bold()
                                            HStack(alignment: .center, spacing: 10){
                                                
                                            }
                                    
                                        }
                                        Spacer().frame(height: overlapOffset)
// Corner radius applies to the background
                                            
                                    }
                                    .padding(20) // Spacing from the screen edges
                                    .frame(maxWidth: .infinity, alignment: .leading) // Ensures the VStack fills width and aligns content left
                                    .background(Color.black.opacity(0.1))
                                    
                                }.frame(width: geo.size.width, height: heroHeight + (minY > 0 ? minY : 0))
                                    .offset(y: minY > 0 ? -minY : -minY * 0.5)
                               
                                
                                
                            }
                            .frame(height: heroHeight)
                            .zIndex(0)
                            
                            VStack(spacing: 12){
                                Text("\(article)")
                            }.padding(.top, 20)
                                .background(Color.white)
                                .cornerRadius(10, corners: [.topLeft, .topRight])
                                .offset(y: -overlapOffset)
                                .zIndex(1)
                            
                            
                        }
                    }
                }}
            
        }
    }
}

#Preview {
    //    ArticleView()
}
