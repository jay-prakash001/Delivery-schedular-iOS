//
//  HomeViewModel.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 21/02/26.
//

import Foundation
import Combine
class HomeViewModel: ObservableObject{
    //    @Published var banners: [BannerFromApi] = []
    @Published var banners: [Banner] = []
    @Published var categories: [ProductCategory] = []
    @Published var offers: [Offer] = []
    @Published var articles: [HomeBlogs] = []
    @Published var calendar : [CalendarData] = []
    
    @Published var homeRes : HomeRes? = nil
    
    @Published var toastString: String?  = nil
    
    // Default trial products used if a banner doesn't define its own
    static let defaultTrialProducts: [TrialProduct] = [
        TrialProduct(id: 1, name: "Cow Milk 500 ml",   mrp: 180, discount: 90),
        TrialProduct(id: 2, name: "Cow Milk 1 L",      mrp: 360, discount: 120),
        TrialProduct(id: 3, name: "Buffalo Milk 500 ml", mrp: 220, discount: 100),
        TrialProduct(id: 4, name: "Buffalo Milk 1 L",  mrp: 440, discount: 150),
        TrialProduct(id: 5, name: "Toned Milk 500 ml", mrp: 140, discount: 60),
    ]
    
    init(){
        loadMockData()
        
        getHomeData()
    }
    
    
    
    func getHomeData(){
        
        Task{
            do{
                let headers = ["Authorization" : UserDefaults.standard.string(forKey: "auth_token") ?? ""]
                var response : HomeRes = try await  APIService.shared.get(
                    urlString: "https://www.freshyzo.com/admin/Customer_App_Api_V1/home", headers: headers)
                
                
                
                homeRes = response
                if response.status{
                    response.data.banner.forEach { body in
                        let intId = Int(body.offerBannerId) ?? 0
                        banners.append(
                            Banner(
                                id: intId,
                                name: body.title,
                                image: body.imgName,
                                price: 0, // No price in API; set a sensible default
                                trialProducts: HomeViewModel.defaultTrialProducts
                            )
                        )
                    }
                    calendar = response.data.calendarData
                    
                    response.data.productCategory.forEach{body in
                        
                        categories.append(body)
                        
                    }
                    
                    
                }
            }catch{
                
            }
        }
    }
    
    func addSugestion(_ text: String){
        Task{
            do{
                let headers = ["Authorization" : UserDefaults.standard.string(forKey: "auth_token") ?? ""]
                var response : GeneralApiResponse = try await  APIService.shared.post(
                    urlString: "https://www.freshyzo.com/admin/Customer_App_Api_V1/submit_suggestion", headers: headers,body: SuggestionReq(suggestion: text))
                
                
                print("Add suggestions \(response)  sent data \(text)")
                
             await    setToastString(response.message)
                
            }
            catch{
                
                print("add suggestions \(error)")
              await   setToastString(error.localizedDescription)
                
            }
        }
        
    }
    
    @MainActor
    func setToastString(_ text: String?) async {
        toastString = text
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        toastString = nil
    }
    
    
    func loadMockData() {
        
        //        banners = [
        //            Banner(
        //                id: 1,
        //                name: "Banner1",
        //                image: "https://static1.squarespace.com/static/638d8044b6fc77648ebcedba/t/67a5b74af834d07712692f36/1738913639066/Top+10+dairy+products+for+your+kitchen+-+Kota+Fresh+Dairy.png?format=1500w",
        //                price : 45,
        //                trialProducts: HomeViewModel.defaultTrialProducts
        //            ),
        //            Banner(
        //                id: 2,
        //                name: "Banner2",
        //                image: "https://asset7.ckassets.com/blog/wp-content/uploads/sites/5/2021/12/Best-Milk-Brands.jpg",
        //                price : 200,
        //                trialProducts: [                                    // ← custom list for this banner
        //                    TrialProduct(id: 1, name: "Cow Milk 500 ml",   mrp: 180, discount: 90),
        //                    TrialProduct(id: 2, name: "Paneer 200g",        mrp: 120, discount: 40),
        //                    TrialProduct(id: 3, name: "Dahi 400g",          mrp: 90,  discount: 30),
        //                               ]
        //
        //            ),
        //            Banner(
        //                id: 3,
        //                name: "Banner3",
        //                image: "https://static1.squarespace.com/static/638d8044b6fc77648ebcedba/t/67a5b74af834d07712692f36/1738913639066/Top+10+dairy+products+for+your+kitchen+-+Kota+Fresh+Dairy.png?format=1500w",
        //                price : 230,
        //                trialProducts: HomeViewModel.defaultTrialProducts
        //            )
        //        ]
        //
        categories = [
            ProductCategory(image: "category1", name: "All Products")
            //            Category(id: 2, name: "Milk Products", image: "category2"),
            //            Category(id: 3, name: "Milk", image: "category3"),
        ]
        
        
        offers = [
            Offer(id: 1, title: "Milk and Ghee", subtitle: "buy ghee and paneer", price: 1000, image: "milk_ghee"),
            Offer(id: 2, title: "Paneer and Dahi", subtitle: "buy ghee and paneer", price: 500, image: "paneer_dahi"),
            Offer(id: 3, title: "Milk and Khowa", subtitle: "buy milk and khowa", price: 1000, image: "milk_khowa")
        ]
        
        //        articles = [
        //            Artical(
        //                id: 1,
        //                title: "Free Grazing vs Shed",
        //                description: "Free Grazing vs Shed Free Grazing vs Shed Free Grazing vs Shed",
        //                image: "https://images.unsplash.com/photo-1567306226416-28f0efdc88ce"
        //            ),
        //            Artical(
        //                id: 2,
        //                title: "Buffalo Milk Benefits",
        //                description: "Free Grazing vs Shed Free Grazing vs Shed Free Grazing vs Shed",
        //                image: "https://images.unsplash.com/photo-1582719478250-c89cae4dc85b"
        //            )
        //        ]
    }
    
}
