//
//  APICaller.swift
//  Spotify-Clone
//
//  Created by Vikas Joshi on 20/11/24.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    private let baseURL = "https://api.spotify.com/v1/"
    
    enum EndPoints {
        static let userProfile = "me"
    }
    
    enum APIErrors {
        static let failureMessage = "Something went wrong!"
    }
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let apiURL = "\(baseURL)\(EndPoints.userProfile)"
        guard let url = convertURLStringToURL(using: apiURL) else { return }
        createRequest(with: url, type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIErrors.failureMessage as! Error))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                    print(result)
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    enum HttpMethods: String {
        case GET
        case POST
    }
    
    // MARK: Private

    private func createRequest(with url: URL?,
                               type: HttpMethods,
                               completion: @escaping (URLRequest) -> Void)
    {
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else { return }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token) ", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            completion(request)
        }
    }
    
    private func convertURLStringToURL(using url: String) -> URL? {
        guard let url = URL(string: url) else { return nil }
        return url
    }
}
