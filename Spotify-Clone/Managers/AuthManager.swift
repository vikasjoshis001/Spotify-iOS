//
//  AuthManager.swift
//  Spotify-Clone
//
//  Created by Vikas Joshi on 20/11/24.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    private var refreshingToken = false
    
    enum Constants {
        static let clientID = "08ad05e9685345f884b19755d4be77d7"
        static let clientSecret = "a8c74f8e158f4160a5199624fc868cfd"
        static let baseURL = "https://accounts.spotify.com/"
        static let redirectURI = "https://shadibiodata.com/"
        static let scope = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    enum EndPoints {
        static let signInAPI = "authorize"
        static let tokenAPI = "api/token"
    }
    
    private init() {}
    
    public var signInURL: URL? {
        let authorizationURL = "\(Constants.baseURL)\(EndPoints.signInAPI)"
        let url = "\(authorizationURL)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scope)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: url)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expiration_date") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)) {
        let tokenAPIURL = "\(Constants.baseURL)\(EndPoints.tokenAPI)"
        guard let url = URL(string: tokenAPIURL) else { return }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                completion(false)
                return
            }
        }
        task.resume()
    }
    
    private var onRefreshingBlocks = [((String) -> Void)]()
    
    public func withValidToken(completion: @escaping (String) -> Void) {
        guard !refreshingToken else {
            self.onRefreshingBlocks.append(completion)
            return
        }
        
        if shouldRefreshToken {
            refreshAccessToken { [weak self] success in
                if let token = self?.accessToken, success {
                    completion(token)
                }
            }
            
        } else if let token = accessToken {
            completion(token)
        }
    }
    
    public func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard !refreshingToken else { return }
        
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        guard let refreshToken = refreshToken else { return }
        
        let tokenAPIURL = "\(Constants.baseURL)\(EndPoints.tokenAPI)"
        guard let url = URL(string: tokenAPIURL) else { return }
        
        refreshingToken = true

        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
            URLQueryItem(name: "client_id", value: Constants.clientID)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            self?.refreshingToken = false
            guard let data = data, error == nil else {
                debugPrint("Failed to refresh access token")
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.onRefreshingBlocks.forEach { $0(result.access_token) }
                self?.onRefreshingBlocks.removeAll()
                debugPrint("Refreshed access token successfully")
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                completion(false)
            }
        }
        task.resume()
    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expiration_date")
    }
}
