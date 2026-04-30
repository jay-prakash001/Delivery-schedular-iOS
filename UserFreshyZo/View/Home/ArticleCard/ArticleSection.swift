//
//  ArticleSection.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 21/02/26.
//

import SwiftUI

struct ArticleSection: View {
    let articles: [Artical]
    var body: some View {
        let isPad = UIDevice.current.userInterfaceIdiom == .pad

        VStack(alignment: .leading) {
                    Text("What type of milk are you familiar with!")
//                        .font(.headline)
                .font(.system(size: isPad ? 24 : 17, weight: .bold))
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                           HStack(spacing: isPad ? 24 : 20) {
                               ForEach(articles) { article in
                                   ArticleCard(article: article)
                               }
                           }
                       }
                    }
                }
    }



#Preview {
    ArticleSection(articles: HomeViewModel().articles)
}
