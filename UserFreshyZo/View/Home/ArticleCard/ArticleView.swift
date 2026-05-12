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
                                        VStack(alignment: .leading,spacing: 10){
                                            Text((article.tag ?? "health and wellness").uppercased())
                                                .font(.subheadline)
                                                .bold()
                                                .foregroundColor(.white)
                                                .padding(.vertical, 6)   // Vertical spacing inside the bubble
                                                .padding(.horizontal, 10) // Horizontal spacing inside the bubble
                                                .background(Color.lightAppGreen.opacity(0.4))
                                                .cornerRadius(20)
                                            
                                            Text(article.title.capitalized).font(.title).bold().foregroundColor(.white)
                                            //                                            HStack(alignment: .center, spacing: 10){
                                            //                                                Image(systemName: "calendar").font(.caption2)
                                            //                                                Text((article. ?? "health and wellness").uppercased()).font(.caption2)
                                            //                                                    .bold()
                                            //
                                            //                                            }
                                                .foregroundColor(.white)
                                                .padding(.vertical, 6)   // Vertical spacing inside the bubble
                                                .padding(.horizontal, 10) // Horizontal spacing inside the bubble
                                                .background(Color.black.opacity(0.1))
                                                .cornerRadius(20)
                                            
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
                            
                            VStack(alignment: .leading,spacing: 12){
                                
                                HStack( spacing: 10){
                                    Image("f_logo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: isPad ? 120 : 30, height: isPad ? 120 : 30)
                                        .background(Color.gray.opacity(0.2)) // Your background color
                                        .clipShape(Circle()) // Cuts the image and background into a circle
                                        .overlay(
                                            Circle()
                                                .stroke(Color.appGreen, lineWidth: 2) // Your border color and thickness
                                        )
                                    
                                    VStack(alignment: .leading){
                                        Text("FreshyZo Team").font(.subheadline).bold()
                                        Text("5 min read").font(.system(size: 10)).fontWeight(.thin)
                                        
                                        
                                        
                                    }
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color(.systemBackground))
                                
                                
                                Text(article.longDescription)                                        .font(.system(size: 16))
                                    .lineSpacing(10)
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.leading).foregroundColor(.black.opacity(0.8))
                                    .padding(.leading, 10)
                                
                                HStack(alignment: .top) {
                                    Image(systemName: "quote.opening")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: isPad ? 40 : 20, height: isPad ? 40 : 20)
                                        .font(.callout)
                                        .foregroundColor(.appGreen)
                                    // Note: quote.opening is already an opening quote.
                                    // 180 deg rotation will make it look like a closing quote.
                                        .rotationEffect(Angle(degrees: 180))
                                    
                                    Text(article.shortDescription)
                                        .font(.system(size: 16)).italic()
                                        .lineSpacing(8)
                                        .lineLimit(nil)
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(.black.opacity(0.8))
                                        .padding(.leading, 10)
                                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .padding() // Space between content and the border
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.appGreen.opacity(0.05)) // Optional: add a background color
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.appGreen, lineWidth: 1)
                                    )
                                
                                
                                
                                
                                
                                
                                
                                
                                VStack(alignment: .leading,spacing: 10){
                                    HStack(alignment: .center,spacing: 4) {
                                        Text("About").font(.subheadline).bold()

                                        Image("freshyzo_logo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: isPad ? 140 : 80)
                                            .font(.callout)
                                            .foregroundColor(.appGreen)
                                    }
                                    Text("We re committed to deliver the purest, farm-fresh A2 milk and dairy products directly to your doorstep with ethical farming practices an unmatched freshness.")
                                        .font(.system(size: 16)).italic()
                                        .lineSpacing(8)
                                        .lineLimit(nil)
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(.black.opacity(0.8))
                                      
                                    
                                    
                                    
                                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .padding(20) // Space between content and the border
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.lightAppGreen.opacity(0.05)) // Optional: add a background color
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.lightAppGreen, lineWidth: 1)
                                    )
                                
                            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                                .padding()
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
