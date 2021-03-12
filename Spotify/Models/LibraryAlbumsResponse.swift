//
//  LibraryAlbumsResponse.swift
//  Spotify
//
//  Created by Shivam Rishi on 12/03/21.
//

import Foundation

struct LibraryAlbumsResponse:Codable {
    let items:[SavedAlbum]
}

struct SavedAlbum:Codable {
    let added_at:String
    let album:Album
}
