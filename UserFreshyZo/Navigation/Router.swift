// MARK: - Router.swift

import SwiftUI
import Combine

final class Router: ObservableObject {

    @Published var navPath = NavigationPath()

    enum Screens: Hashable {
        case wellComeSlider
        case login_phone
        case login_otp
        case mainTab
        case signUpName
        case signUpMap
    }

    func navigate(to screen: Screens) {
        navPath.append(screen)
    }

    func replaceWithClearBackStack(with screen: Screens) {
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
