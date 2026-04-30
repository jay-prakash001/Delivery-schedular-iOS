//
//  AccountViewModel.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 28/03/26.
//


import Foundation
import SwiftUI
import Combine

class AccountViewModel: ObservableObject {
    
    // MARK: - Profile
    @Published var name: String = "User Name"
    @Published var phoneNumber: String = ""
    @Published var dateOfBirth: Date = Date()
    @Published var email: String = ""
    @Published var profileImage: UIImage? = nil
    @Published var isSaved: Bool = false
    
    // MARK: - Image Picker
    @Published var showImagePicker: Bool = false
    
    // MARK: - Logout
    @Published var showLogoutConfirm: Bool = false
    @Published var isLoggedOut: Bool = false
    
    // MARK: - Init
    init() {
        loadProfile()
    }
    
    // MARK: - Load Profile (Mock / Local)
    func loadProfile() {
        // TODO: Replace with API call
        name        = UserDefaults.standard.string(forKey: "profile_name")  ?? "User Name"
        phoneNumber = UserDefaults.standard.string(forKey: "profile_phone") ?? ""
        email       = UserDefaults.standard.string(forKey: "profile_email") ?? ""
        
        if let dob = UserDefaults.standard.object(forKey: "profile_dob") as? Date {
            dateOfBirth = dob
        }
        
        if let data = UserDefaults.standard.data(forKey: "profile_image"),
           let image = UIImage(data: data) {
            profileImage = image
        }
    }
    
    // MARK: - Save Profile
    func saveChanges() {
        // Save locally via UserDefaults
        UserDefaults.standard.set(name,        forKey: "profile_name")
        UserDefaults.standard.set(phoneNumber, forKey: "profile_phone")
        UserDefaults.standard.set(email,       forKey: "profile_email")
        UserDefaults.standard.set(dateOfBirth, forKey: "profile_dob")
        
        if let image = profileImage,
           let data = image.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(data, forKey: "profile_image")
        }
        
        // TODO: Replace with API call
        // APIService.shared.saveProfile(profile)
        
        isSaved = true
        print("✅ Profile saved: \(name), \(phoneNumber), \(email)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isSaved = false
        }
    }
    
    // MARK: - Logout
    func logout() {
        // TODO: Clear token / session
        UserDefaults.standard.removeObject(forKey: "profile_name")
        UserDefaults.standard.removeObject(forKey: "profile_phone")
        UserDefaults.standard.removeObject(forKey: "profile_email")
        UserDefaults.standard.removeObject(forKey: "profile_dob")
        UserDefaults.standard.removeObject(forKey: "profile_image")
        
        isLoggedOut = true
        print("🚪 User logged out")
    }
    
    // MARK: - Formatted Date
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd / MM / yyyy"
        return formatter.string(from: dateOfBirth)
    }
    
    // MARK: - Fetch Profile from API (future)
    func fetchProfileFromAPI() {
        // guard let url = URL(string: "https://freshyzo.com/admin/Customer_App_Api/fetch_profile") else { return }
        // URLSession.shared.dataTask(with: url) { ... }.resume()
    }
    
    // MARK: - Update Profile via API (future)
    func updateProfileAPI() {
        // APIService.shared.updateProfile(...)
    }
}
