//
//  ViewController.swift
//  iTunesSearchDemo
//
//  Created by cm0678 on 2022/12/20.
//

import UIKit
import SDWebImage

class SearchViewController: UIViewController {
    
    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "Search by name, description or author"
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseIdentifier)
        tableView.rowHeight = 70
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var viewModel: SearchViewModel = {
        let viewModel = SearchViewModel()
        viewModel.delegate = self
        return viewModel
    }()
    
    private var searchTask: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(tableView)
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                searchBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
                searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
                tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTask?.cancel()
        let searchTask = DispatchWorkItem(qos: .background) { [weak self] in
            self?.viewModel.searchMusic(keyword: searchText)
        }
        self.searchTask = searchTask
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: searchTask)
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier, for: indexPath) as! SearchTableViewCell
        
        if let result = viewModel.getResult(atIndexPath: indexPath) {
            cell.artworkImageView.sd_setImage(with: URL(string: result.artworkUrl30))
            cell.artistNameLabel.text = result.artistName
            cell.trackNameLabel.text = result.trackName
        }
        
        return cell
    }
}

extension SearchViewController: SearchViewModelDelegate {
    
    func didSearched() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func searchFailed(error: NetworkError) {
        Logger.log(error)
    }
}
