//
//  Helpers.swift
//  Spotify-Clone
//
//  Created by Vikas Joshi on 20/11/24.
//

import Foundation

// Method to get the localized version of the string
extension String {
    public func localized() -> String{
        let localizedString = NSLocalizedString(self, comment: "")
        
        if localizedString == self {
            let fallbackBundle = Bundle.main.path(forResource: "en", ofType: "lproj").flatMap { Bundle(path: $0) }
            return fallbackBundle?.localizedString(forKey: self, value: nil, table: nil) ?? self
        }
        
        return localizedString
    }
}
