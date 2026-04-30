import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showCart = false
    @EnvironmentObject var cartVM: CartViewModel
    @State private var selectedCategory = "All Products"
    @EnvironmentObject var router: Router

    // Logic to hide the floating cart on specific tabs (Wallet, Account, Cart)
    var shouldShowCart: Bool {
        cartVM.totalItems > 0 && (selectedTab == 0 || selectedTab == 1)
    }

    var body: some View {
        // We do NOT put a NavigationStack here because
        // the Router provides it at the root level.
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView(selectedTab: $selectedTab, selectedCategory: $selectedCategory)
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag(0)
                
                ProductView(selectedTab: $selectedTab, selectedCategoryFromHome: selectedCategory)
                    .tabItem {
                        Label("Products", systemImage: "bag")
                    }
                    .tag(1)
                
                WalletView()
                    .tabItem {
                        Label("Wallet", systemImage: "creditcard.fill")
                    }
                    .tag(2)
                
                AccountView()
                    .tabItem {
                        Label("Account", systemImage: "person.fill")
                    }
                    .tag(3)
                
                CartView(selectedTab: $selectedTab)
                    .tabItem {
                        Label("Cart", systemImage: "cart")
                    }
                    .tag(4)
            }
            .accentColor(.green)
            
            // Floating Bottom Cart UI
            if shouldShowCart {
                BottomCartView(selectedTab: $selectedTab)
                    .padding(.horizontal, 16)
                    // Offset moves it above the standard TabBar height (~49-60pt)
                    .padding(.bottom, 65)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        // This ensures that when we are in the MainTab,
        // the back button from Splash/Login doesn't appear.
        .navigationBarHidden(true)
        .animation(.spring(), value: shouldShowCart)
    }
}
