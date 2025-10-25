import Foundation

struct Http {
    
    static func isSuccessCode(_ statusCode: Int) -> Bool {
        return (200 <= statusCode && statusCode < 300)
    }
    
    /// Decodes an API response from FastAPI.
    ///
    /// - Parameters:
    ///   - data: The raw JSON data returned by the API.
    ///   - type: The expected type of the decoded object.
    /// - Returns: The decoded object of the specified type.
    /// - Throws: An error if decoding fails.
    static func decode<T: Decodable>(_ data: Data, to type: T.Type) throws -> T {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            
            // Decode the response directly (FastAPI returns pure JSON)
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Decoding failed for type: \(type)")
            print("Error: \(error.localizedDescription)")
            print("Full error details: \(error)") // Prints the complete error object
            throw APIError.decodingFailed
        }
    }
    
    static func sendPostRequest<T: Encodable>(payload: T, to endpoint: String, expectedStatus:Int = 200) async throws -> (Data, Int) {
        let serverUrl = UserDefaults.standard.string(forKey:"serverURL");
        if serverUrl == nil {
            throw APIError.invalidURL
        }
                
        let authKey = UserDefaults.standard.string(forKey: "authKey")
        if authKey == nil {
            throw APIError.invalidAuthKey
        }
        
        // using ! to force the unwrap as is confirmed above that if we get here there is a value to unwrap
        let domain = UserDefaults.standard.string(forKey:"serverURL")! + endpoint
        
        guard let url = URL(string: domain) else { throw APIError.invalidURL }
        
        // Create a URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // Set the HTTP method to POST

        // Add Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(authKey!, forHTTPHeaderField: "X-Auth-Key")

        // Encode the payload to JSON
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .useDefaultKeys
            request.httpBody = try encoder.encode(payload)
        } catch {
            print("Encoding failed for payload: \(payload)")
            print("Error: \(error.localizedDescription)")
            throw APIError.encodingFailed
        }

        // Use URLSession to send the request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
        }
        
        if httpResponse.statusCode != expectedStatus {
            // Log the status code and server response
            print("Unexpected status code: \(httpResponse.statusCode)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("Server response: \(responseString)")
            } else {
                print("Unable to decode server response.")
            }
            throw APIError.invalidResponse
        }

        return (data, httpResponse.statusCode)
    }
    
    static func sendGetRequest(to endpoint: String, expectedStatus: Int = 200) async throws -> (Data, Int) {
        let serverUrl = UserDefaults.standard.string(forKey:"serverURL")
        if serverUrl == nil {
            throw APIError.invalidURL
        }
        
        let authKey = UserDefaults.standard.string(forKey: "authKey")
        if authKey == nil {
            throw APIError.invalidAuthKey
        }
        print("authKey: \(authKey!)")
        
        let domain = UserDefaults.standard.string(forKey:"serverURL")! + endpoint
        
        guard let url = URL(string: domain) else { throw APIError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(authKey!, forHTTPHeaderField: "X-Auth-Key")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        if httpResponse.statusCode != expectedStatus {
            print("Unexpected status code: \(httpResponse.statusCode)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("Server response: \(responseString)")
            }
            throw APIError.invalidResponse
        }
        
        return (data, httpResponse.statusCode)
    }
    
    static func sendPatchRequest<T: Encodable>(payload: T, to endpoint: String, expectedStatus: Int = 200) async throws -> (Data, Int) {
        let serverUrl = UserDefaults.standard.string(forKey:"serverURL")
        if serverUrl == nil {
            throw APIError.invalidURL
        }
        
        let authKey = UserDefaults.standard.string(forKey: "authKey")
        if authKey == nil {
            throw APIError.invalidAuthKey
        }
        
        let domain = UserDefaults.standard.string(forKey:"serverURL")! + endpoint
        
        guard let url = URL(string: domain) else { throw APIError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(authKey!, forHTTPHeaderField: "X-Auth-Key")
        
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .useDefaultKeys
            request.httpBody = try encoder.encode(payload)
        } catch {
            print("Encoding failed for payload: \(payload)")
            print("Error: \(error.localizedDescription)")
            throw APIError.encodingFailed
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        if httpResponse.statusCode != expectedStatus {
            print("Unexpected status code: \(httpResponse.statusCode)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("Server response: \(responseString)")
            }
            throw APIError.invalidResponse
        }
        
        return (data, httpResponse.statusCode)
    }
    
    static func sendPutRequest<T: Encodable>(payload: T, to endpoint: String, expectedStatus: Int = 200) async throws -> (Data, Int) {
        let serverUrl = UserDefaults.standard.string(forKey:"serverURL")
        if serverUrl == nil {
            throw APIError.invalidURL
        }
        
        let authKey = UserDefaults.standard.string(forKey: "authKey")
        if authKey == nil {
            throw APIError.invalidAuthKey
        }
        
        let domain = UserDefaults.standard.string(forKey:"serverURL")! + endpoint
        
        guard let url = URL(string: domain) else { throw APIError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(authKey!, forHTTPHeaderField: "X-Auth-Key")
        
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .useDefaultKeys
            request.httpBody = try encoder.encode(payload)
        } catch {
            print("Encoding failed for payload: \(payload)")
            print("Error: \(error.localizedDescription)")
            throw APIError.encodingFailed
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        if httpResponse.statusCode != expectedStatus {
            print("Unexpected status code: \(httpResponse.statusCode)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("Server response: \(responseString)")
            }
            throw APIError.invalidResponse
        }
        
        return (data, httpResponse.statusCode)
    }
    
    static func sendDeleteRequest(to endpoint: String, expectedStatus: Int = 204) async throws -> Int {
        let serverUrl = UserDefaults.standard.string(forKey:"serverURL")
        if serverUrl == nil {
            throw APIError.invalidURL
        }
        
        let authKey = UserDefaults.standard.string(forKey: "authKey")
        if authKey == nil {
            throw APIError.invalidAuthKey
        }
        
        let domain = UserDefaults.standard.string(forKey:"serverURL")! + endpoint
        
        guard let url = URL(string: domain) else { throw APIError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue(authKey!, forHTTPHeaderField: "X-Auth-Key")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        if httpResponse.statusCode != expectedStatus {
            print("Unexpected status code: \(httpResponse.statusCode)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("Server response: \(responseString)")
            }
            throw APIError.invalidResponse
        }
        
        return httpResponse.statusCode
    }
}
