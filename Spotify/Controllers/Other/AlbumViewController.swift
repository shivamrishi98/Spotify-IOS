//
//  AlbumViewController.swift
//  Spotify
//
//  Created by Shivam Rishi on 26/02/21.
//

import UIKit

class AlbumViewController: UIViewController {

    private let album:Album
    
    init(album:Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = album.name
        
        ApiManager.shared.getAlbumDetails(for: album) { result in
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
