//
//  Product.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 21/02/26.
//

import Foundation

struct Product: Identifiable, Codable {
    
    let id: String
    let productName: String
    let shortDesc: String
    let description: String
    let image: String
    let price: String
    let mrp: String
    let categoryName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "product_id"
        case productName = "product_name"
        case shortDesc = "short_desc"
        case description = "description"
        case image = "dairy_product_image"
        case price = "product_price"
        case mrp = "dairy_mrp"
        case categoryName = "product_category_name"
    }
    
    var imageURL: URL? {
        URL(string: "https://freshyzo.com/admin/uploads/product_image/\(image)")
    }
}

extension Product {

    var quantityText: String {

        let pattern = #"(\d+\s?(ml|gm|kg|lit))"#

        if let range = productName.lowercased()
            .range(of: pattern, options: .regularExpression) {
            
            return String(productName[range])
        }

        return ""
    }
}

extension Product {

    var cleanName: String {

        let pattern = #"\s?\d+\s?(ml|gm|kg|lit).*"#

        return productName
            .replacingOccurrences(of: pattern, with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespaces)
    }
}

extension Product {

    var cleanCategory: String {

        let name = productName.lowercased()

        if name.contains("milk") {
            return "Milk"
        }
        else if name.contains("dahi") {
            return "Dahi"
        }
        else if name.contains("paneer") {
            return "Paneer"
        }
        else if name.contains("ghee") {
            return "Ghee"
        }
        else if name.contains("khowa") {
            return "khowa"
        }

        return "Other"
    }
}
