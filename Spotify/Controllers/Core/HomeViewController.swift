//
//  ViewController.swift
//  Spotify
//
//  Created by Shivam Rishi on 16/02/21.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home"
        self.view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSettings))
        fetchData()
    }
    
    
    private func fetchData() {
        ApiManager.shared.getRecommendedGenres { result in
           
            switch result {
            case .success(let model):
                
                let genres = model.genres
                var seeds = Set<String>()
                
                while seeds.count < 4 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }
            
                ApiManager.shared.getRecommendations(genres: seeds) { result in
                   
                }
                
            case .failure(let error):
                break
            }
            
            
        }
    }
    
    @objc private func didTapSettings() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    


}

