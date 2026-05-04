// MARK: - Router.swift

import SwiftUI
import Combine

final class AuthRouter: ObservableObject {

    @Published var navPath = NavigationPath()

    enum Auth: Hashable {
        case login_phone
        case login_otp
        case signUpName
        case signUpMap
    }

    func navigate(to screen: Auth) {
        navPath.append(screen)
    }

    func replaceWithClearBackStack(with screen: Auth) {
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
