//
//  ArticleCard.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 21/02/26.
//

import SwiftUI

struct ArticleCard: View {
    

    let article: HomeBlogs
    @EnvironmentObject var mainRouter : MainRouter
    var body: some View {
        
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        VStack(spacing: 0) {

            // IMAGE
            AsyncImage(url: URL(string: article.imageUrl)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                default:
                    Color.gray.opacity(0.2)
                }
            }
            .frame(height: isPad ? 140 : 80)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous)) // 👈 image rounded
            .padding(.horizontal, 8) // 👈 internal spacing from card edges
            .padding(.top, 8)

            // CONTENT
            VStack(alignment: .leading, spacing: 2) {
                Text(article.title)
                    .font(isPad ? .title3 : .subheadline)
                    .bold()

                Text(article.shortDescription)
                    .font(isPad ? .body : .caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                Spacer()

                Button{
                    mainRouter.navigate(to: .article(article: article))
                } label:{
                    Text("Learn More")
                        .foregroundColor(Color("AppGreenColor"))
                        .font(isPad ? .body : .caption)
                }
                
            }
            .padding(8) // 👈 content padding
        }
        .frame(width: isPad ? 260 : 160, height: isPad ? 260 : 200)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous)) // 👈 main card
        .shadow(color: .black.opacity(0.08), radius: 5, y: 3).padding(.bottom,4)
        .onTapGesture{
            mainRouter.navigate(to: .article(article: article))

        }
    }
}
//#Preview {
//    ArticleCard(
//        article: HomeBlogs(
////            id: 1,
//            title: "Free Grazing vs Shed",
//            description: "descriptiondescriptiondescription",
//            image: "https://images.unsplash.com/photo-1567306226416-28f0efdc88ce"
//        )
//    )
//}

