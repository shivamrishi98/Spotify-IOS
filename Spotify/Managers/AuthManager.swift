//
//  AuthManager.swift
//  Spotify
//
//  Created by Shivam Rishi on 16/02/21.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    struct Constants {
       static let clientID = "8d34c9c9d16c447981b11948ace1412e"
       static let clientSecret = "69ee2b0a762e406fa1e846917560f2de"
    }
    
    
    private init(){}
    
    public var signInUrl:URL? {
        let scopes = "user-read-private"
        let redirectUri = "Https://www.iosacademy.io"
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectUri)&show_dialog=TRUE"
        
        return URL(string: string)
    }
    
    var isSignedIn:Bool {
        return false
    }
    
    private var accessToken:Bool? {
        return nil
    }
    
    private var refreshToken:Bool? {
        return nil
    }
    
    private var tokenExpirationDate:Date? {
        return nil
    }
    
    private var shouldRefreshToken:Bool? {
        return nil
    }
    
    public func exchangeCodeForToken(
        code:String,
        completion: @escaping ((Bool) -> Void)
    ) {
        //Get Token
        
    }
    
    public func refreshAccessToken() {
        
    }
    
    private func cacheToken() {
        
    }
    
}
