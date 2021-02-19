//
//  SettingsModels.swift
//  Spotify
//
//  Created by Shivam Rishi on 19/02/21.
//

import Foundation

struct Section {
    let title:String
    let options:[Option]
}

struct Option {
    let title:String
    let handler: () -> Void
}
