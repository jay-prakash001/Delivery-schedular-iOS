import SwiftUI

struct WellComeSliderItemView: View {
    
    let title: String
    let msg: String
    let lottieName: String
    
    var body: some View {
        VStack {
            
            ZStack {
                Circle()
                    .fill(.wellcomeSliderImgBg)
                    .frame(width: 300, height: 300)
                
                LottieView(name: lottieName)
                    .frame(width: 150, height: 150)
            }
            
            Spacer()
                .frame(height: 20)
            
            Text(title)
                .bold()
                .font(.title2)
            
            Text(msg)
                .font(.body)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding()
        }
    }
}

#Preview {
    WellComeSliderItemView(
        title: "Easily track your orders",
        msg: "Track deliveries, manage subscriptions, and order on the go with our user-friendly app.",
        lottieName: "empty_cart"
    )
}
