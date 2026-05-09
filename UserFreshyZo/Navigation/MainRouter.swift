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
        case productdetails(id : String)
        case subscriptionstart( product : ProductFromApi, quantity : Int )
        case allreview
        case referandearn
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

    func navigateToRoot() {
        navPath = NavigationPath()
    }
}

