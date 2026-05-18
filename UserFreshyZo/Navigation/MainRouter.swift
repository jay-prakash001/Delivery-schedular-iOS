//
//  MainRouter.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 04/05/26.
//

// MARK: - Router.swift

import SwiftUI
import Combine

final class MainRouter: ObservableObject {

    @Published var navPath = NavigationPath()

    enum MainFlow: Hashable {
        case maintab
        case milkbanneroffer(banner : Banner)
        case testreports
        case article(article : HomeBlogs)
        case productdetails(id : String)
        case subscriptionstart( product : ProductFromApi, mediaUrls: [ProductAsset], quantity : Int, offers: [ProductOffer] )
        case allreview
        case referandearn
        case walletrechargehistory(rechargeHistory : [RechargeHistory])
        case invoice
        case generateinvoice(startDate: String, endDate: String)
        case vacation
        case deliveries
        case orders
    }

    func navigate(to screen: MainFlow) {
        navPath.append(screen)
    }

    func replaceWithClearBackStack(with screen: MainFlow) {
        navPath = NavigationPath()
        navPath.append(screen)
    }

    func navigateBack() {
        if !navPath.isEmpty {
            navPath.removeLast()
        }
    }
    
    func resetToRoot() {
            // Clearing the path pops everything off the stack back to the root view
            navPath = NavigationPath()
        }

    func navigateToRoot() {
        navPath = NavigationPath()
    }
}

