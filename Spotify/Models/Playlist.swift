//
//  Playlist.swift
//  Spotify
//
//  Created by Shivam Rishi on 16/02/21.
//

import Foundation


struct Playlist:Codable {
    let description:String
    let external_urls:[String:String]
    let id:String
    let images:[APIImage]
    let name:String
    let owner:User
}

struct User:Codable {
    let display_name:String
    let external_urls:[String:String]
    let id:String
}
