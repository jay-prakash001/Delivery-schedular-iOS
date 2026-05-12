//import Foundation
//



import Foundation
import UIKit

enum HTTPMethod: String {
    case GET, POST, PUT, PATCH, DELETE
}

enum APIError: Error {
    case invalidURL, invalidResponse, decodingError, unauthorized
}

// The generic wrapper for your API
struct APIResponse<T: Decodable>: Decodable {
    let status: Bool?
    let message: String?
    let data: T?
}

final class APIService {
    static let shared = APIService()
    private init() {}
    
    private func performRequest<T: Decodable, U: Encodable>(
        urlString: String,
        method: HTTPMethod,
        headers: [String: String?] = [:],
        body: U? = nil,
        retryCount: Int = 0
    ) async throws -> T {
        
        guard let url = URL(string: urlString) else { throw APIError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = UserDefaults.standard.string(forKey: "auth_token") {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        if let body = body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // --- STEP 1: PEEK FOR AUTH LOGIC ---
        let rawJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        let message = rawJson?["message"] as? String ?? ""

        // Token Expired Logic
        if message.localizedCaseInsensitiveContains("Token expired") && retryCount < 1 {
            if let dataDict = rawJson?["data"] as? [String: Any],
               let newToken = dataDict["token"] as? String {
                UserDefaults.standard.set(newToken, forKey: "auth_token")
                return try await performRequest(urlString: urlString, method: method, headers: headers, body: body, retryCount: retryCount + 1)
            }
        }

        // Unauthorized Logic
        if message.localizedCaseInsensitiveContains("Unauthorized access") {
            UserDefaults.standard.removeObject(forKey: "auth_token")
//            NotificationCenter.default.post(name: NSNotification.Name("LogoutUser"), object: nil)
            throw APIError.unauthorized
        }

        // --- STEP 2: FLEXIBLE DECODING ---
        let decoder = JSONDecoder()
        
        // 1. Try to decode the APIResponse Wrapper first
        if let wrapped = try? decoder.decode(APIResponse<T>.self, from: data), let actualData = wrapped.data {
            return actualData
        }
        
        // 2. If no "data" field exists (like OTP calls), try to decode T directly from the root
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Decoding Failed: \(error)")
            throw APIError.decodingError
        }
    }

    // Convenience Methods
    func post<T: Decodable, U: Encodable>(urlString: String, headers: [String: String?] = [:], body: U) async throws -> T {
        try await performRequest(urlString: urlString, method: .POST, headers: headers, body: body)
    }
    
    func get<T: Decodable>(urlString: String, headers: [String: String?] = [:]) async throws -> T {
        try await performRequest(urlString: urlString, method: .GET, headers: headers, body: Optional<String>.none)
    }
}

