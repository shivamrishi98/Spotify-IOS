//
//  UserProfile.swift
//  Spotify
//
//  Created by Shivam Rishi on 16/02/21.
//

import Foundation

struct UserProfile:Codable {
    let country:String
    let display_name:String
    let email:String
    let id:String
    let product:String
    let images:[UserImage]
}

struct UserImage:Codable {
    let url:String
}
