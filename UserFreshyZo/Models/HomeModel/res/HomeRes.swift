import Foundation

// MARK: - Home Response
struct HomeRes: Codable {
    let data: HomeData
    let message: String
    let status: Bool
}

// MARK: - Data Container
struct HomeData: Codable {
    let banner: [BannerFromApi]
    let calendarData: [CalendarData]
    let productCategory: [ProductCategory]
    let testReport: [TestReport]
    let blogs: [HomeBlogs]?

    enum CodingKeys: String, CodingKey {
        case banner
        case calendarData = "calendar_data"
        case productCategory = "product_category"
        case testReport = "test_report"
        case blogs = "blog"
    }
}

// MARK: - Banner
struct BannerFromApi: Codable, Identifiable {
    var id: String { offerBannerId } // Conform to Identifiable for SwiftUI Lists
    let imgName: String
    let offerBannerId: String
    let title: String

    enum CodingKeys: String, CodingKey {
        case imgName = "img_name"
        case offerBannerId = "offer_banner_id"
        case title
    }
}

// MARK: - Calendar Data
struct CalendarData: Codable, Identifiable {
    var id: String { date }
    let date: String
    let day: String
    let dayNum: String
    let hasDelivery: Bool
    let hasVacation: Bool
    let items: [CalendarItem]
    let remainingBalance: Int

    enum CodingKeys: String, CodingKey {
        case date, day, items
        case dayNum = "day_num"
        case hasDelivery = "has_delivery"
        case hasVacation = "has_vacation"
        case remainingBalance = "remaining_balance"
    }
}

// MARK: - Calendar Item
struct CalendarItem: Codable, Identifiable {
    var id: String { productId }
    let image: String
    let productId: String
    let productName: String
    let qty: String
    let type: String

    enum CodingKeys: String, CodingKey {
        case image, qty, type
        case productId = "product_id"
        case productName = "product_name"
    }
}

// MARK: - Product Category
struct ProductCategory: Codable, Identifiable {
    var id: String { productCategoryName }
    let categoryImage: String
    let productCategoryName: String

    enum CodingKeys: String, CodingKey {
        case categoryImage = "category_image"
        case productCategoryName = "product_category_name"
    }
}

// MARK: - Test Report
struct TestReport: Codable, Identifiable {
    var id: String { testReportId }
    let acidity, antibiotics, causticSoda, date: String
    let detergent, fat, milkType, snf: String
    let starch, testReportId, urea: String

    enum CodingKeys: String, CodingKey {
        case acidity, antibiotics, date, detergent, fat, snf, starch, urea
        case causticSoda = "caustic_soda"
        case milkType = "milk_type"
        case testReportId = "test_report_id"
    }
}

// MARK: - Home Suggestion
struct HomeSuggestion: Codable {
    let suggestion: String
}



// MARK: - Home Blogs
struct HomeBlogs: Codable, Identifiable {
    // We create a unique ID based on title and image since the API
    // doesn't provide a specific ID field here.
    var id: String { title + imageUrl }
    
    let title: String
    let tag: String?
    let shortDescription: String
    let longDescription: String
    let imageUrl: String

    enum CodingKeys: String, CodingKey {
        case title
        case tag
        case shortDescription = "short_desc"
        case longDescription = "description"
        case imageUrl = "image"
    }
    
    static var fromApi: HomeBlogs {
        HomeBlogs(
            title: "Benefits of Fresh Milk",
            tag: "Health",
            shortDescription: "Learn why farm-fresh milk is better for your bones.",
            longDescription: "Farm-fresh milk contains essential nutrients that are often lost in heavy processing...",
            imageUrl: "https://example.com/blog_image.jpg"
        )
    }
}
