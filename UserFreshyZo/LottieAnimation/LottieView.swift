//
//  LottieView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 10/03/26.
//

import SwiftUI
import Lottie




struct LottieView: UIViewRepresentable {
    
    
    let name: String
    var loopMode: LottieLoopMode = .loop
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        // Create the animation view
        let animationView = LottieAnimationView()
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        
        // --- Support for both .lottie and .json ---
        
        // 1. Try to load as a DotLottie file first (.lottie)
        DotLottieFile.named(name) { result in
            switch result {
            case .success(let dotLottieFile):
                animationView.loadAnimation(from: dotLottieFile)
                animationView.play()
            case .failure:
                // 2. Fallback: Try to load as a standard JSON animation
                if let animation = LottieAnimation.named(name) {
                    animationView.animation = animation
                    animationView.play()
                } else {
                    print("❌ Lottie Error: Could not find animation named \(name) in .lottie or .json format")
                }
            }
        }
        
        // Setup Constraints
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Here you could handle play/pause updates if you added @Binding properties
    }
}

//#Preview {
//    // This works whether your file is "empty_cart.json" or "empty_cart.lottie"
//    LottieView(name: "empty_cart")
//        .frame(width: 250, height: 250)
//}

#Preview {
    LottieView(name: "deliveryanim")
        .frame(width: 250, height: 250)

}
