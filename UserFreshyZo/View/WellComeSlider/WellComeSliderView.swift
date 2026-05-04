import SwiftUI

struct WellComeSliderView: View {
    @EnvironmentObject  var authViewModel : AuthViewModel
    @EnvironmentObject  var router :AuthRouter
    
    
    
    struct Slide: Identifiable {
        let id = UUID()
        let title: String
        let msg: String
        let lottieName: String
    }
    
    @State private var currentPage = 0
    @State private var navigateToLogin = false
    
    let slides = [
        Slide(
            title: "Easily track your orders",
            msg: "Track deliveries, manage subscriptions, and order on the go with our user-friendly app.",
            lottieName: "empty_cart"
        ),
        Slide(
            title: "Fresh groceries delivered fast",
            msg: "Choose from fruits, vegetables, dairy and more with quick doorstep delivery.",
            lottieName: "empty_cart"
        ),
        Slide(
            title: "Secure and simple payments",
            msg: "Pay with confidence using fast and secure checkout options.",
            lottieName: "empty_cart"
        )
    ]
    
    var body: some View {
        
            
            VStack {
                
                // MARK: Top App Bar
                HStack {
                    
                    
                    
                    if currentPage != 0 {
                        
                        Button("Back") {
                            if currentPage > 0{
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentPage -= 1
                                }
                            }
                        }
                        .font(.headline)
                        .foregroundColor(.gray)
                    }else{
                        
                        Spacer()
                            .frame(width: 40)
                        
                    }
                    
                    Spacer()
                    
                    
                    if  currentPage != slides.count - 1 {
                        Button("Skip") {
                            
                            router.navigate(to:  .login_phone)
                        }
                        .font(.headline)
                        .foregroundColor(.gray)
                    } else {
                        Spacer()
                            .frame(width: 40)
                    }
                }
                .padding()
                
                Spacer()
                
                // MARK: Pager
                TabView(selection: $currentPage) {
                    ForEach(Array(slides.enumerated()), id: \.offset) { index, item in
                        
                        WellComeSliderItemView(
                            title: item.title,
                            msg: item.msg,
                            lottieName: item.lottieName
                        )
                        .tag(index)
                        .padding(.horizontal)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 500)
                
                // MARK: Custom Indicators
                HStack(spacing: 8) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        
                        Capsule()
                            .fill(index == currentPage ? .green : .gray.opacity(0.4))
                            .frame(
                                width: index == currentPage ? 28 : 10,
                                height: 10
                            )
                            .animation(.easeInOut(duration: 0.25), value: currentPage)
                    }
                }
                .padding(.top, 20)
                
                Spacer()
                Button("Continue") {
                    if currentPage < slides.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    }else{
                        
                        router.replaceWithClearBackStack(with: .login_phone)
//                        navigateToLogin = /*true*/
                        
                    }
                }
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.green)
                .cornerRadius(14)
                .padding(.horizontal)
                
                
                
            }
            
//            .navigationDestination(isPresented: $navigateToLogin,){
//                LoginView().environmentObject(authViewModel).environmentObject(router).navigationBarHidden(true)
//            }
        }
        
        
    
    
}

#Preview {
    //    WellComeSliderView(authViewModel: AuthViewModel())
}
