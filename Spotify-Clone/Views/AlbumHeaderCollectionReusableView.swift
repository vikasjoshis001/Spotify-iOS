//
//  AlbumHeaderCollectionReusableView.swift
//  Spotify-Clone
//
//  Created by Vikas Joshi on 29/11/24.
//

import UIKit
import SDWebImage

protocol AlbumHeaderCollectionReusableViewDelegate: AnyObject {
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: AlbumHeaderCollectionReusableView)
}

class AlbumHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = Constants.PLAYLIST_HEADER
    
    weak var delegate: AlbumHeaderCollectionReusableViewDelegate?
    
    private let albumCoverImageView: UIImageView = {
        let albumCoverImageView = UIImageView()
        albumCoverImageView.image = UIImage(systemName: "photo")
        albumCoverImageView.contentMode = .scaleAspectFill
        return albumCoverImageView
    }()
    
    private let albumNameLabel: UILabel = {
        let albumNameLabel = UILabel()
        albumNameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        albumNameLabel.numberOfLines = 0
        albumNameLabel.textColor = .white
        return albumNameLabel
    }()
    
    private let albumOwnerNameLabel: UILabel = {
        let albumOwnerNameLabel = UILabel()
        albumOwnerNameLabel.font = .systemFont(ofSize: 14, weight: .regular)
        albumOwnerNameLabel.numberOfLines = 0
        albumOwnerNameLabel.textColor = .white
        return albumOwnerNameLabel
    }()
    
    private let albumDescriptionLabel: UILabel = {
        let albumDescriptionLabel = UILabel()
        albumDescriptionLabel.font = .systemFont(ofSize: 14, weight: .light)
        albumDescriptionLabel.numberOfLines = 0
        albumDescriptionLabel.textColor = .white
        return albumDescriptionLabel
    }()
    
    private let playAllButton: UIButton = {
        let playAllButton = UIButton()
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        playAllButton.setImage(image, for: .normal)
        playAllButton.layer.cornerRadius = 30
        playAllButton.layer.masksToBounds = true
        playAllButton.backgroundColor = .systemGreen
        playAllButton.tintColor = .white
        return playAllButton
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        addSubview(albumCoverImageView)
        addSubview(albumNameLabel)
        addSubview(albumDescriptionLabel)
        addSubview(albumOwnerNameLabel)
        addSubview(playAllButton)
        playAllButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize = height/1.5
        albumCoverImageView.frame = CGRect(x: (width-imageSize)/2, y: 20, width: imageSize, height: imageSize)
        albumNameLabel.frame = CGRect(x: 10, y: albumCoverImageView.bottom + 10, width: (width-20), height: 20)
        albumOwnerNameLabel.frame = CGRect(x: 10, y: albumNameLabel.bottom, width: (width-20), height: 20)
        albumDescriptionLabel.frame = CGRect(x: 10, y: albumOwnerNameLabel.bottom, width: (width-20), height: 40)
        playAllButton.frame = CGRect(x: width - 70, y: height - 80, width: 60, height: 60)

    }
    
    override func prepareForReuse() {
        albumCoverImageView.image = nil
        albumNameLabel.text = nil
        albumOwnerNameLabel.text = nil
        albumDescriptionLabel.text = nil
    }
    
    @objc func didTapPlayAll() {
        delegate?.PlaylistHeaderCollectionReusableViewDidTapPlayAll(self)
    }
    
    func configure(with viewModel: AlbumHeaderViewModel) {
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL)
        albumNameLabel.text = viewModel.name
        albumOwnerNameLabel.text = viewModel.ownerName
        albumDescriptionLabel.text = viewModel.description
    }
}
