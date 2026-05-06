import SwiftUI

// MARK: - AccountView (Main Container)

struct AccountView: View {
    
    @StateObject var vm = AccountViewModel()
    
    var body: some View {
            VStack(spacing: 0) {
                AccountHeaderView()
                    .padding()
                    .background(Color.white)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        WelcomeCardView(vm: vm)
                        QuickAccessSectionView()
                        AccountSettingsSectionView(vm: vm)
                        SupportInfoSectionView()
                        FooterLinksView()
                        LogoutButtonView(vm: vm)
                        AppVersionView()
                        
                        Spacer().frame(height: 80)
                    }
                    .padding()
                }
                .background(Color(.systemGroupedBackground))
            }
            .navigationBarHidden(true)                      // ← add this
            .confirmationDialog("Are you sure you want to log out?",
                                isPresented: $vm.showLogoutConfirm,
                                titleVisibility: .visible) {
                Button("Log Out", role: .destructive) { vm.logout() }
                Button("Cancel", role: .cancel) {}
            }
        }                                                   // ← close NavigationStack
    
}

// MARK: - Preview

#Preview {
    AccountView()
}
