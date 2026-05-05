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

    @StateObject var authViewModel = AuthViewModel()
    var body: some Scene {
        WindowGroup {
            
            SplashView()
//            HomeCalendarDialog(calendarData: dummyCalendarData){
//                
//            }

                .environmentObject(authViewModel)
                .preferredColorScheme(.light)
        }
    }
}


