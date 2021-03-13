//
//  LibraryPlaylistsViewController.swift
//  Spotify
//
//  Created by Shivam Rishi on 08/03/21.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {
    
    private var playlists = [Playlist]()
    
    private let noPlaylistsView = ActionLabelView()
    
    public var selectionHandler: ((Playlist) -> Void)?
    
    private let tableView:UITableView = {
        let tableView = UITableView(frame: .zero,
                                    style: .grouped)
        tableView.register(SearchResultSubTitleTableViewCell.self,
                           forCellReuseIdentifier: SearchResultSubTitleTableViewCell.identifier)
        tableView.isHidden = true
         return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setupNoPlaylistsView()
        fetchData()
        
        if selectionHandler != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                               target: self,
                                                               action: #selector(didTapClose))
        }
        
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
        
        noPlaylistsView.frame = CGRect(x: 0,
                                       y: 0,
                                       width: 150,
                                       height: 150)
        noPlaylistsView.center = view.center
    }
    
    private func setupNoPlaylistsView() {
        view.addSubview(noPlaylistsView)
        noPlaylistsView.delegate = self
        noPlaylistsView.configure(with: ActionLabelViewViewModel(
                                    text: "You don't have any playlist yet.",
                                    actionTitle: "Create"))
    }
    
    private func fetchData() {
        ApiManager.shared.getCurrentUserPlaylists { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlists):
                    self?.playlists = playlists
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateUI() {

        if playlists.isEmpty {
            // Show label
            noPlaylistsView.isHidden = false
            tableView.isHidden = true
        } else {
            // Show tableview
            tableView.isHidden = false
            noPlaylistsView.isHidden = true
            tableView.reloadData()
        }
    }
    
    public func showCreatePlaylistAlert() {
        let alert = UIAlertController(title: "New Playlists",
                                      message: "Enter Playlist Name",
                                      preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.placeholder = "Playlist..."
        }
        
        alert.addAction(
            UIAlertAction(
                title: "Create",
                style: .default,
                handler: { _ in
                    guard let field = alert.textFields?.first,
                          let text = field.text,
                          !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                        return
                    }
                    
                    ApiManager.shared.createPlaylist(with: text) { [weak self] success in
                        if success {
                            HapticsManager.shared.vibrate(for: .success)
                            // Refresh list of playlists
                            self?.fetchData()
                        } else {
                            HapticsManager.shared.vibrate(for: .error)
                            print("Failed to create playlist")
                        }
                    }
                    
                }))
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))
        
        present(alert, animated: true)
    }
    
}

extension LibraryPlaylistsViewController:ActionLabelViewDelegate {
    
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        showCreatePlaylistAlert()
    }
    
}

extension LibraryPlaylistsViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultSubTitleTableViewCell.identifier,
                for: indexPath) as? SearchResultSubTitleTableViewCell else {
            return UITableViewCell()
        }
        let playlist = playlists[indexPath.row]
        let viewModel = SearchResultSubTitleTableViewCellViewModel(
            title: playlist.name,
            subtitle: playlist.owner.display_name,
            imageUrl:URL(string: playlist.images.first?.url ?? ""))
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,
                              animated: true)
        HapticsManager.shared.vibrateForSelection()
        let playlist = playlists[indexPath.row]
        
        guard selectionHandler == nil else {
            selectionHandler?(playlist)
            dismiss(animated: true, completion: nil)
            return
        }
        
        let vc = PlaylistViewController(playlist: playlist)
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.isOwner = true
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
