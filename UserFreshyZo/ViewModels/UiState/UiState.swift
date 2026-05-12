//
//  UiState.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 12/05/26.
//

import Foundation


enum UiState<T> {
    case idle
    case loading
    case success(T)
    case error(String)
    case tokenexpire(String)
    case unauthorized(GeneralApiResponse)
}
