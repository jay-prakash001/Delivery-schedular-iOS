//
//  SuggestionView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 21/02/26.
//

import SwiftUI

struct SuggestionView: View {
    
    @State private var suggestionText: String = ""
    
    var body: some View {
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        
        VStack(alignment: .leading, spacing: isPad ? 22 : 16) {
            
            // Top Row (Title + Logo)
            HStack(alignment: .top) {
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Tell us what you want!")
//                        .font(.system(size: 18, weight: .bold))
                        .font(.system(size: isPad ? 24 : 18, weight: .bold))

                    
                    Text("Suggest products that you want us to make available to shop or feature to add on FreshyZo")
//                        .font(.system(size: 14))
                        .font(.system(size: isPad ? 18 : 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Small Logo Box
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
//                        .frame(width: 50, height: 50)
                        .frame(width: isPad ? 70 : 50, height: isPad ? 70 : 50)

                    
                    Image("f_logo")
                        .resizable()
                        .scaledToFit()
//                        .frame( height: 48)
                        .frame(height: isPad ? 60 : 48)

                }
            }
            
            // Input + Button Row
            HStack(spacing: 12) {
                
                TextField("type here..", text: $suggestionText)
//                    .padding()
                    .padding(isPad ? 18 : 12)

                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("AppGreenColor"), lineWidth: 1.5)
                    )
                
                Button(action: {
                    print("Send tapped")
                }) {
                    Text("Send")
                        .foregroundColor(.white)
//                        .frame(width: 80, height: 50)
                    
                        .font(.system(size: isPad ? 18 : 15, weight: .semibold))
                        .frame(width: isPad ? 100 : 80,
                                                      height: isPad ? 60 : 50)
                        .background(Color("AppGreenColor"))
                        .cornerRadius(12)
                }
            }
        }
//        .padding(20)
        .padding(isPad ? 28 : 20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)

    }
}
#Preview {
    SuggestionView()
}
