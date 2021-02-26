//
//  PlaylistViewController.swift
//  Spotify
//
//  Created by Shivam Rishi on 16/02/21.
//

import UIKit

class PlaylistViewController: UIViewController {

    private let playlist:Playlist
    
    init(playlist:Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = playlist.name
        
        ApiManager.shared.getPlaylistDetails(for: playlist) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    break
                case .failure(let error):
                    break
                }
            }
        }
        
    }

}
