//
//  SearchTableViewCell.swift
//  iTunesSearchDemo
//
//  Created by cm0678 on 2022/12/20.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    lazy var artworkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        
        contentView.addSubview(artworkImageView)
        contentView.addSubview(nameStackView)
        
        NSLayoutConstraint.activate([
            artworkImageView.widthAnchor.constraint(equalToConstant: 50),
            artworkImageView.heightAnchor.constraint(equalTo: artworkImageView.widthAnchor),
            artworkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            artworkImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameStackView.leadingAnchor.constraint(equalTo: artworkImageView.trailingAnchor, constant: 10),
            nameStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
}
