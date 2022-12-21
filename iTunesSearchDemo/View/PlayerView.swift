//
//  SmallPlayerView.swift
//  iTunesSearchDemo
//
//  Created by cm0678 on 2022/12/20.
//

import UIKit

class PlayerView: UIView {

    lazy var artworkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var trackNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var playbackButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "button_play"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = .gray
        view.tintColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        let nameStackView = UIStackView()
        nameStackView.axis = .vertical
        nameStackView.distribution = .fillEqually
        nameStackView.spacing = 5
        nameStackView.translatesAutoresizingMaskIntoConstraints = false
        nameStackView.addArrangedSubview(trackNameLabel)
        nameStackView.addArrangedSubview(artistNameLabel)
        
        addSubview(artworkImageView)
        addSubview(nameStackView)
        addSubview(playbackButton)
        addSubview(closeButton)
        addSubview(loadingView)
        addSubview(progressView)
        
        NSLayoutConstraint.activate([
            artworkImageView.topAnchor.constraint(equalTo: topAnchor),
            artworkImageView.bottomAnchor.constraint(equalTo: progressView.topAnchor),
            artworkImageView.widthAnchor.constraint(equalTo: artworkImageView.heightAnchor),
            artworkImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            nameStackView.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -10),
            nameStackView.leadingAnchor.constraint(equalTo: artworkImageView.trailingAnchor, constant: 10),
            nameStackView.trailingAnchor.constraint(equalTo: playbackButton.leadingAnchor, constant: -10),
            closeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            playbackButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            playbackButton.widthAnchor.constraint(equalTo: closeButton.widthAnchor),
            playbackButton.heightAnchor.constraint(equalTo: closeButton.heightAnchor),
            playbackButton.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -20),
            loadingView.centerXAnchor.constraint(equalTo: playbackButton.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: playbackButton.centerYAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 10),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func setPlay() {
        playbackButton.setImage(UIImage(named: "button_play"), for: .normal)
        playbackButton.isHidden = false
        loadingView.isHidden = true
        loadingView.stopAnimating()
    }
    
    func setPause() {
        playbackButton.setImage(UIImage(named: "button_pause"), for: .normal)
        playbackButton.isHidden = false
        loadingView.isHidden = true
        loadingView.stopAnimating()
    }
    
    func setLoad() {
        playbackButton.isHidden = true
        loadingView.isHidden = false
        loadingView.startAnimating()
    }
    
    func updateProgress(_ progress: Float) {
        progressView.progress = progress
    }
}
