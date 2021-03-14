//
//  SettingsViewController.swift
//  Spotify
//
//  Created by Shivam Rishi on 16/02/21.
//

import UIKit

class SettingsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    private let tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "Settings"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        configureModels()
    }
    
    private func configureModels()
    {
        sections.append(
            Section(title: "Profile",
                    options: [
                        Option(title: "View Your Profile", handler: { [weak self] in
                            self?.viewPofile()
                        })
                    ]))
        
        sections.append(
            Section(title: "Account",
                    options: [
                        Option(title: "Sign Out", handler: { [weak self] in
                            self?.signOutTapped()
                        })
                    ]))
        
        
    }
    
    private func viewPofile()
    {
        let vc = ProfileViewController()
        vc.title = "Profile"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func signOutTapped()
    {
        AuthManager.shared.signOut { [weak self] signedOut in
            if signedOut {
                let alert = UIAlertController(title: "Sign Out",
                                              message: "Are you sure?",
                                              preferredStyle: .alert)
                alert.addAction(
                    UIAlertAction(
                        title: "Sign Out",
                        style: .destructive,
                        handler: { _ in
                            DispatchQueue.main.async {
                                let navVC = UINavigationController(rootViewController: WelcomeViewController())
                                navVC.navigationBar.prefersLargeTitles = true
                                navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
                                navVC.modalPresentationStyle = .fullScreen
                                self?.present(navVC,animated: true, completion: {
                                    self?.navigationController?.popToRootViewController(animated: false)
                                })
                            }
                        }))
                alert.addAction(
                    UIAlertAction(
                        title: "Cancel",
                        style: .cancel,
                        handler: nil))
                present(alert,
                        animated: true)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - TableView

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //Call handler for cell
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = sections[section]
        
        return model.title
    }
    
    
    
}
