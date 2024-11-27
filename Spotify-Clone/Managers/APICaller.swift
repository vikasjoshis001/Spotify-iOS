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
    
    // MARK: - Constants

    enum EndPoints {
        static let userProfile = "me"
        static let browseNewReleases = "browse/new-releases"
        static let browseFeaturedPlaylists = "browse/featured-playlists?limit=2"
        static let recommendations = "recommendations"
        static let recommendationGenres = "recommendations/available-genre-seeds"
    }
    
    enum APIErrors {
        static let failureMessage = "Something went wrong!"
    }
    
    enum HttpMethods: String {
        case GET
        case POST
    }
    
    // MARK: - Helpers

    private func createRequest(with url: URL?,
                               type: HttpMethods,
                               completion: @escaping (URLRequest) -> Void)
    {
        debugPrint("API URL:- ", url ?? "")
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else { return }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token) ", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            completion(request)
        }
    }
    
    private func convertURLStringToURL(using url: String) -> URL? {
        let apiUrl = "\(baseURL)\(url)"
        guard let url = URL(string: apiUrl) else { return nil }
        return url
    }
    
    // MARK: - Get current user profile

    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let url = convertURLStringToURL(using: EndPoints.userProfile)
        createRequest(with: url, type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIErrors.failureMessage as! Error))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Get new releases

    public func getNewReleases(completion: @escaping (Result<NewReleasesResponse, Error>) -> Void) {
        let url = convertURLStringToURL(using: EndPoints.browseNewReleases)
        createRequest(with: url, type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else { return }
                do {
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Get features playlists

    public func getFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylistsResponse, Error>) -> Void) {
        let url = convertURLStringToURL(using: EndPoints.browseFeaturedPlaylists)
        createRequest(with: url, type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIErrors.failureMessage as! Error))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Get recommendations

    public func getRecommendations(seed_genres: Set<String>, completion: @escaping (Result<RecommendationsResponse, Error>) -> Void) {
        let genres = seed_genres.joined(separator: ",")
        let url = convertURLStringToURL(using: "\(EndPoints.recommendations)?seed_genres=\(genres)&limit=40")
        createRequest(with: url, type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIErrors.failureMessage as! Error))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Get recommendations genres

    public func getRecommendationsGenres(completion: @escaping (Result<RecommendedGenresResponse, Error>) -> Void) {
        let url = convertURLStringToURL(using: EndPoints.recommendationGenres)
        createRequest(with: url, type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIErrors.failureMessage as! Error))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
}
