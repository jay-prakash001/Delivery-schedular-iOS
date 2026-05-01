//
//  UserFreshyZoApp.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 21/02/26.
//

import SwiftUI




import GoogleMaps

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Provide your Google Maps API Key here
        GMSServices.provideAPIKey("AIzaSyCeATEzCO0x7VxVVHV23Rg_FLAUnaO6iMU")
        
        return true
    }
}
@main
struct UserFreshyZoApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject var cartVM = CartViewModel()
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var router = Router()
    var body: some Scene {
        WindowGroup {
            
//            SplashView()
            NavigationStack {
                SignUpMapView()
                    .environmentObject(AuthViewModel())
            }
                .environmentObject(cartVM)
                .environmentObject(authViewModel)
                .environmentObject(router)
                .preferredColorScheme(.light)
        }
    }
}


