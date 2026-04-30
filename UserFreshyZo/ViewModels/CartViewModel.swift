//
//  CartViewModel.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 19/03/26.
//
import Foundation
import Combine

class CartViewModel: ObservableObject {

    @Published var items: [CartItem] = [] {
        didSet {
            saveCart()
        }
    }

    private let key = "cart_items"

    init() {
        loadCart()
    }

    func addItem(
        id: String,
        name: String,
        price: Double,
        mrp: Double,
        image: String,
        variant: String? = nil
    ) {
        if let index = items.firstIndex(where: { $0.id == id }) {
            items[index].quantity += 1
        } else {
            let newItem = CartItem(
                id: id,
                quantity: 1,
                name: name,
                price: price,
                mrp: mrp,
                image: image,
                variant: variant
            )
            items.append(newItem)
        }
    }

    func removeItem(id: String) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }

        if items[index].quantity > 1 {
            items[index].quantity -= 1
        } else {
            items.remove(at: index)
        }
    }

    private func saveCart() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func loadCart() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([CartItem].self, from: data) {
            items = decoded
        }
    }

    var totalItems: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    var totalPrice: Double {
        items.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }

    var totalMRP: Double {
        items.reduce(0) { $0 + ($1.mrp * Double($1.quantity)) }
    }

    var totalDiscount: Double {
        max(0, totalMRP - totalPrice)
    }
}
