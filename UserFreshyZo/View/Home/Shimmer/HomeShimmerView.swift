//
//  HomeShimmerView.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 15/05/26.
//

import SwiftUI

struct HomeShimmerView: View {
    var body: some View {
        // Wrap everything in a ScrollView so the whole page is scrollable
        // if it exceeds the height
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                
                HeaderView(walletAmount: "0")
                
                // Horizontal Section
                VStack(alignment: .leading, spacing: 10) {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(0..<10, id: \.self) { _ in
                                ShimmerBox(width: 60, height: 80, cornerRadius: 12)
                            }
                        }
                    }
                }
                
                // Large Banner Shimmer
                ShimmerBox(height: 150)
                    .frame(maxWidth: .infinity)
                
                // Grid/Row Shimmer
                HStack(spacing: 15) {
                    ForEach(0..<3, id: \.self) { _ in
                        ShimmerBox(height: 100)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                // Vertical List Shimmers
                ForEach(0..<3, id: \.self) { _ in
                    ShimmerBox(height: 120)
                        .frame(maxWidth: .infinity)
                }
                
                Spacer()
            }
            .padding() // Apply padding ONCE to the container
        }
    }
}


struct ShimmerBox: View {
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    var cornerRadius: CGFloat = 10
    
    @State private var phase: CGFloat = -1
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color(white: 0.9)) // Light gray base
            .frame(width: width, height: height)
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .white.opacity(0.6), location: 0.5),
                            .init(color: .clear, location: 1)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width * 0.7) // Width of the highlight
                    .offset(x: phase * geo.size.width)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 1.5)
                        .repeatForever(autoreverses: false)
                ) {
                    phase = 1.5
                }
            }
    }
}
#Preview {
    HomeShimmerView()
}
