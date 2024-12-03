//
//  NewReleaseCollectionViewCell.swift
//  Spotify-Clone
//
//  Created by Vikas Joshi on 27/11/24.
//

import UIKit
import SDWebImage

class NewReleaseCollectionViewCell: UICollectionViewCell {
    static let identifier = Constants.NEW_RELEASE
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let albumNameLabel = UILabel()
        albumNameLabel.textColor = .white
        albumNameLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        albumNameLabel.numberOfLines = 0
        return albumNameLabel
    }()
    
    private let numberOfTracksLabel: UILabel = {
        let numberOfTracksLabel = UILabel()
        numberOfTracksLabel.textColor = .white
        numberOfTracksLabel.font = .systemFont(ofSize: 14, weight: .light)
        numberOfTracksLabel.numberOfLines = 0
        return numberOfTracksLabel
    }()
    
    private let artistNameLabel: UILabel = {
        let artistName = UILabel()
        artistName.textColor = .white
        artistName.font = .systemFont(ofSize: 14, weight: .light)
        artistName.numberOfLines = 0
        return artistName
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(hex: "#101020")
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(numberOfTracksLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height - 20
        let albumNameLabelSize = albumNameLabel.sizeThatFits(
            CGSize(
                width: contentView.width - imageSize - 20,
                height: contentView.height - 10)
        )
        let albumNameLabelHeight = min(60, albumNameLabelSize.height)
        
        albumNameLabel.sizeToFit()
        artistNameLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()
        
        albumCoverImageView.frame = CGRect(x: 5,
                                           y: 10,
                                           width: imageSize,
                                           height: imageSize)
        
        albumNameLabel.frame = CGRect(x: albumCoverImageView.right + 10,
                                      y: 10,
                                      width: albumNameLabelSize.width,
                                      height: albumNameLabelHeight)
        
        artistNameLabel.frame = CGRect(x: albumCoverImageView.right + 10,
                                       y: albumNameLabel.bottom,
                                       width: contentView.width - albumCoverImageView.right - 10,
                                       height: 30)

        numberOfTracksLabel.frame = CGRect(x: albumCoverImageView.right + 10,
                                           y: albumCoverImageView.bottom - 35,
                                           width: numberOfTracksLabel.width,
                                           height: 44)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        numberOfTracksLabel.text = nil
        artistNameLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configure(with viewModel: NewReleasesCellViewModel) {
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL)
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)"
    }
}
