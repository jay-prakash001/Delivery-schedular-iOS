import Foundation

// MARK: - Root Response
struct ProductDetailResponse: Codable {
    let status: Bool
    let message: String
    let data: ProductDetailData
}

// MARK: - Data Container
struct ProductDetailData: Codable, Equatable {
   
    let productDetails: [ProductFromApi]
    let productAssets: [ProductAsset] // Updated from [String] to [ProductAsset]
    let productFaq: [ProductFAQ]
    let productOffers: [ProductOffer]
    let review: ReviewContainer

    enum CodingKeys: String, CodingKey {
        case productDetails = "product_details"
        case productAssets = "product_assets"
        case productFaq = "product_faq"
        case review
        case productOffers = "offer"
    }
}

// MARK: - Product Asset
struct ProductAsset: Codable, Identifiable, Equatable, Hashable {
    // Unique ID for SwiftUI ForEach loops
    var id: String { asset }
    let asset: String
    
    // Helper to distinguish between image and video
    var isVideo: Bool {
        asset.lowercased().hasSuffix(".mp4")
    }
}

// MARK: - Product Detail
struct ProductDetail: Codable, Identifiable {
    var id: String { productId }
    
    let productId: String
    let productSubCategoryId: String
    let productName: String
    let shortDesc: String
    let description: String
    let descTag: String
    let unit: String
    let productPrice: String
    let dairyMrp: String
    let subscription: String

    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case productSubCategoryId = "product_sub_category_id"
        case productName = "product_name"
        case shortDesc = "short_desc"
        case description, unit, subscription
        case descTag = "desc_tag"
        case productPrice = "product_price"
        case dairyMrp = "dairy_mrp"
    }
    
    // Decodes the stringified JSON array in desc_tag
    var tags: [String] {
        guard let data = descTag.data(using: .utf8) else { return [] }
        return (try? JSONDecoder().decode([String].self, from: data)) ?? []
    }
}

// MARK: - FAQ & Reviews (Same as before)
struct ProductFAQ: Codable, Equatable {
    let id = UUID()
    let qus: String
    let ans: String
    
    // Content-based equality to avoid UUID differences counting as changes
    static func == (lhs: ProductFAQ, rhs: ProductFAQ) -> Bool {
        lhs.qus == rhs.qus && lhs.ans == rhs.ans
    }
}

struct ReviewContainer: Codable, Equatable {
    let writeReview: Bool
    let feedbacks: [Feedback]

    enum CodingKeys: String, CodingKey {
        case writeReview = "write_review"
        case feedbacks
    }
}

struct Feedback: Codable, Identifiable, Equatable {
    var id: String { feedbackId }
    let feedbackId, customerId, productId, productSubCategoryId: String
    let productRating, serviceRating, feedback, timeStamp: String
    let feedbackStatus, customerName: String

    enum CodingKeys: String, CodingKey {
        case feedbackId = "feedback_id"
        case customerId = "customer_id"
        case productId = "product_id"
        case productSubCategoryId = "product_sub_category_id"
        case productRating = "product_rating"
        case serviceRating = "service_rating"
        case feedback
        case timeStamp = "time_stamp"
        case feedbackStatus = "feedback_status"
        case customerName = "customer_name"
    }
}

struct ProductOffer: Codable, Identifiable, Equatable, Hashable {
    
    // MARK: - ID
    var id: String { offerId }
    
    // MARK: - Properties
    let offerId: String
    let productId: String
    let days: String
    let amount: String
    let offPercent: String
    let freeMilk: String
    let couponCode: String

    enum CodingKeys: String, CodingKey {
        case offerId = "offer_id"
        case productId = "product_id"
        case days
        case amount
        case offPercent = "off_percent"
        case freeMilk = "free_milk"
        case couponCode = "coupon_code"
    }
    
    // MARK: - Helpers
    
    /// Final amount after discount
    var displayAmount: Int {
        Int(amount) ?? 0
    }
    
    /// Discount percentage label
    var discountLabel: String {
        "\(offPercent)% OFF"
    }
    
    /// Discount percentage as Int
    var offPercentageValue: Int {
        Int(offPercent) ?? 0
    }
    
    /// Original amount before discount
    var originalAmount: Int {
        let percent = Double(offPercentageValue) / 100
        let original = Double(displayAmount) * (1 + percent)
        return Int(original.rounded())
    }
    
    /// Saved amount
    var offAmount: Int {
        originalAmount - displayAmount
    }
    
    /// Extract first number from "3 Months"
    var durationValue: Int {
        Int(days.components(separatedBy: " ").first ?? "") ?? 0
    }
    
    /// Extract second word from "3 Months"
    var durationType: String {
        days.components(separatedBy: " ").dropFirst().first ?? ""
    }
    
    /// Total deliveries
    /// Example:
    /// 3 Months = 3 * 30 = 90
    var totalDeliveries: Int {
        if durationType.lowercased().contains("month") {
            return durationValue * 30
        } else if durationType.lowercased().contains("week") {
            return durationValue * 7
        } else {
            return durationValue
        }
    }
}
