//
//  FeaturedPlaylistsResponse.swift
//  Spotify
//
//  Created by Shivam Rishi on 21/02/21.
//

import Foundation

struct FeaturedPlaylistsResponse: Codable {
    let playlists:PlaylistResponse
}

struct CategoryPlaylistsResponse: Codable {
    let playlists:PlaylistResponse
}

struct PlaylistResponse:Codable {
    let items:[Playlist]
}
