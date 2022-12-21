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
    
    private lazy var playerView: PlayerView = {
        let view = PlayerView()
        view.playbackButton.addTarget(self, action: #selector(playbackButtonDidTap), for: .touchUpInside)
        view.closeButton.addTarget(self, action: #selector(closePlayerViewButtonDidTap), for: .touchUpInside)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var viewModel: SearchViewModel = {
        let viewModel = SearchViewModel(repository: SearchResultRepositoryImpl())
        viewModel.delegate = self
        return viewModel
    }()
    
    private lazy var player: AVPlayerAdapter = {
        let player = AVPlayerAdapter()
        player.delegate = self
        return player
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
    
    @objc private func playbackButtonDidTap() {
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
    }
    
    @objc private func closePlayerViewButtonDidTap() {
        player.stop()
        removePlayerView()
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTask?.cancel()
        let searchTask = DispatchWorkItem(qos: .background) { [weak self] in
            self?.viewModel.searchMusic(keyword: searchText)
        }
        self.searchTask = searchTask
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: searchTask)
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let playItem = viewModel.getResult(atIndexPath: indexPath) else { return }
        
        play(playItem: playItem)
    }
    
    private func play(playItem: SearchResultEntity) {
        guard let url = URL(string: playItem.previewURL) else { return }
        addPlayerViewIfNeeded()
        updatePlayerView(playItem: playItem)
        player.load(with: url,
                    metaData: AVPlayerMediaMetadata(title: playItem.trackName,
                                                    albumTitle: playItem.collectionName,
                                                    artist: playItem.artistName,
                                                    imageUrl: playItem.artworkUrl100),
                    autoStart: true)
    }
    
    private func addPlayerViewIfNeeded() {
        
        guard !view.subviews.contains(playerView) else { return }
        
        let height: CGFloat = 80
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
        view.addSubview(playerView)
        NSLayoutConstraint.activate([
            playerView.heightAnchor.constraint(equalToConstant: height),
            playerView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func removePlayerView() {
        playerView.removeFromSuperview()
        tableView.contentInset = .zero
    }
    
    private func updatePlayerView(playItem: SearchResultEntity) {
        playerView.artworkImageView.sd_setImage(with: URL(string: playItem.artworkUrl60))
        playerView.artistNameLabel.text = playItem.artistName
        playerView.trackNameLabel.text = playItem.trackName
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier, for: indexPath) as! SearchTableViewCell
        
        if let result = viewModel.getResult(atIndexPath: indexPath) {
            cell.artworkImageView.sd_setImage(with: URL(string: result.artworkUrl60))
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
        showAlert(title: error.getErrorMessage())
        Logger.log(error)
    }
}

extension SearchViewController: AVPlayerAdapterDelegate {
    
    func didStateChange(_ state: AVPlayerState) {
        switch state {
        case .initialization:
            playerView.setLoad()
        case .unknown:
            showAlert(title: "Error", message: "unknown error")
        case .readyToPlay: break
        case .playing:
            playerView.setPause()
        case .paused, .stoped:
            playerView.setPlay()
        case .failed(let error):
            playerView.setPlay()
            showAlert(title: "Error", message: error?.localizedDescription ?? "unknown error")
        case .waitingForNetwork:
            playerView.setLoad()
        case .playToEnd:
            playerView.setPlay()
        }
    }
    
    func didCurrentTimeChange(currentTime: Double) {
    }
    
    func didCurrentTimeChange(progress: Float) {
        playerView.updateProgress(progress)
    }
}
