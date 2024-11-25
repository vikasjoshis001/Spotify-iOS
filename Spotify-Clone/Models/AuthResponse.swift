//
//  AuthResponse.swift
//  Spotify-Clone
//
//  Created by Vikas Joshi on 21/11/24.
//

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
} 
