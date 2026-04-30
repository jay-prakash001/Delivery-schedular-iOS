import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, PATCH, DELETE
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}

final class APIService {
    
    static let shared = APIService()
    private init() {}
    
    // 🔹 Core request handler (private)
    private func performRequest<T: Decodable, U: Encodable>(
        urlString: String,
        method: HTTPMethod,
        headers: [String: String] = [:],
        body: U? = nil
    ) async throws -> T {
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Default header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Custom headers
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        // Encode body if present
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw APIError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
}


extension APIService {
    func get<T: Decodable>(
        urlString: String,
        headers: [String: String] = [:]
    ) async throws -> T {
        return try await performRequest(
            urlString: urlString,
            method: .GET,
            headers: headers,
            body: Optional<Data>.none
        )
    }
}

extension APIService {
    func post<T: Decodable, U: Encodable>(
        urlString: String,
        headers: [String: String] = [:],
        body: U
    ) async throws -> T {
        return try await performRequest(
            urlString: urlString,
            method: .POST,
            headers: headers,
            body: body
        )
    }
}


extension APIService {
    func put<T: Decodable, U: Encodable>(
        urlString: String,
        headers: [String: String] = [:],
        body: U
    ) async throws -> T {
        return try await performRequest(
            urlString: urlString,
            method: .PUT,
            headers: headers,
            body: body
        )
    }
}

extension APIService {
    func patch<T: Decodable, U: Encodable>(
        urlString: String,
        headers: [String: String] = [:],
        body: U
    ) async throws -> T {
        return try await performRequest(
            urlString: urlString,
            method: .PATCH,
            headers: headers,
            body: body
        )
    }
}

extension APIService {
    func delete<T: Decodable>(
        urlString: String,
        headers: [String: String] = [:]
    ) async throws -> T {
        return try await performRequest(
            urlString: urlString,
            method: .DELETE,
            headers: headers,
            body: Optional<Data>.none
        )
    }
}
