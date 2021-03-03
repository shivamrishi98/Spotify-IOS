//
//  SearchResult.swift
//  Spotify
//
//  Created by Shivam Rishi on 03/03/21.
//

import Foundation

enum SearchResult {
    case artist(model:Artist)
    case album(model:Album)
    case track(model:AudioTrack)
    case playlist(model:Playlist)
}
