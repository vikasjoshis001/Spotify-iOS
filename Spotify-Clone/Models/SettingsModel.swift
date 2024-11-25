//
//  SettingsModel.swift
//  Spotify-Clone
//
//  Created by Vikas Joshi on 25/11/24.
//

import Foundation

struct Section {
    let title: String
    let options: [Options]
}

struct Options {
    let title: String
    let handler: () -> Void
}
