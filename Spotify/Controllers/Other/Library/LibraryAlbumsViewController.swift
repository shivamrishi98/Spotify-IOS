//
//  LibraryAlbumsViewController.swift
//  Spotify
//
//  Created by Shivam Rishi on 08/03/21.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {

    private var albums = [Album]()
    
    private let noAlbumsView = ActionLabelView()
    
    private let tableView:UITableView = {
        let tableView = UITableView(frame: .zero,
                                    style: .grouped)
        tableView.register(SearchResultSubTitleTableViewCell.self,
                           forCellReuseIdentifier: SearchResultSubTitleTableViewCell.identifier)
        tableView.isHidden = true
         return tableView
    }()
    
    private var observer:NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setupNoAlbumsView()
        fetchData()
        observer = NotificationCenter.default.addObserver(
            forName: .albumSavedNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                self?.fetchData()
            })
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: view.width,
                                 height: view.height)
        
        noAlbumsView.frame = CGRect(x: (view.width-150)/2,
                                    y: (view.height-150)/2,
                                    width: 150,
                                    height: 150)
    }
    
    private func setupNoAlbumsView() {
        view.addSubview(noAlbumsView)
        noAlbumsView.delegate = self
        noAlbumsView.configure(with: ActionLabelViewViewModel(
                                    text: "You have not saved any albums yet.",
                                    actionTitle: "Browse"))
    }
    
    private func fetchData() {
        albums.removeAll()
        ApiManager.shared.getCurrentUserAlbums { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let albums):
                    self?.albums = albums
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateUI() {

        if albums.isEmpty {
            // Show label
            noAlbumsView.isHidden = false
            tableView.isHidden = true
        } else {
            // Show tableview
            tableView.isHidden = false
            noAlbumsView.isHidden = true
            tableView.reloadData()
        }
    }

    
}

extension LibraryAlbumsViewController:ActionLabelViewDelegate {
    
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        tabBarController?.selectedIndex = 0
    }
    
}

extension LibraryAlbumsViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultSubTitleTableViewCell.identifier,
                for: indexPath) as? SearchResultSubTitleTableViewCell else {
            return UITableViewCell()
        }
        let album = albums[indexPath.row]
        
        let viewModel = SearchResultSubTitleTableViewCellViewModel(
            title: album.name,
            subtitle: album.artists.first?.name ?? "-",
            imageUrl:URL(string: album.images.first?.url ?? ""))
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,
                              animated: true)
        let album = albums[indexPath.row]
        
        let vc = AlbumViewController(album: album)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
