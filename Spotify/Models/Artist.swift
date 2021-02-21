//
//  Artist.swift
//  Spotify
//
//  Created by Shivam Rishi on 16/02/21.
//

import Foundation

struct Artist:Codable {
    let id:String
    let name:String
    let type:String
    let external_urls:[String:String]
}
