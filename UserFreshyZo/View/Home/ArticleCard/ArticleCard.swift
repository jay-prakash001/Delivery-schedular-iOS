//
//  ArticleCard.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 21/02/26.
//

import SwiftUI

struct ArticleCard: View {
    
    let article: Artical
    
    var body: some View {
        
        let isPad = UIDevice.current.userInterfaceIdiom == .pad

        VStack(alignment: .leading, spacing: 4) {
            
                AsyncImage(url: URL(string: article.image)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                        
                    default:
                        Color.gray.opacity(0.2)
                    }
                }
//                .frame(height: 120)
                .frame(height: isPad ? 160 : 120)
                .clipped()
                .cornerRadius(15)
                
                Text(article.title)
//                    .font(.subheadline)
                .font(isPad ? .title3 : .subheadline)
                    .bold()
                
                Text(article.description)
//                    .font(.caption)
                .font(isPad ? .body : .caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
//                    .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
          
            
            Text("Learn More")
                .foregroundColor(Color("AppGreenColor"))
//                .font(.caption)
                .font(isPad ? .body : .caption)

        }
//        .frame(width: 190, height: 200)
        .frame(width: isPad ? 260 : 190, height: isPad ? 260 : 200)
        .padding()
        .background(RoundedRectangle(cornerRadius: 15)
            .fill(Color.white))
        .shadow(color: .black.opacity(0.08), radius: 5, y: 3)
    }
}
#Preview {
    ArticleCard(
        article: Artical(
            id: 1,
            title: "Free Grazing vs Shed",
            description: "descriptiondescriptiondescription",
            image: "https://images.unsplash.com/photo-1567306226416-28f0efdc88ce"
        )
    )
}

