//
//  RecomendedTrackCollectionViewCell.swift
//  Spotify-Clone
//
//  Created by Vikas Joshi on 27/11/24.
//

import UIKit
import SDWebImage

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = Constants.RECOMMENDED_TRACK
    
    private let trackCoverImageView: UIImageView = {
        let trackCoverImageView = UIImageView()
        trackCoverImageView.image = UIImage(systemName: "photo")
        trackCoverImageView.contentMode = .scaleAspectFill
        return trackCoverImageView
    }()
    
    private let trackNameLabel: UILabel = {
        let trackNameLabel = UILabel()
        trackNameLabel.textColor = .white
        trackNameLabel.font = .systemFont(ofSize: 18, weight: .regular)
        trackNameLabel.numberOfLines = 0
        return trackNameLabel
    }()
    
    private let trackOwnerNameLabel: UILabel = {
        let trackOwnerNameLabel = UILabel()
        trackOwnerNameLabel.textColor = .white
        trackOwnerNameLabel.font = .systemFont(ofSize: 14, weight: .light)
        trackOwnerNameLabel.numberOfLines = 0
        return trackOwnerNameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(hex: "#101020")
        contentView.addSubview(trackCoverImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(trackOwnerNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize = 50
        trackCoverImageView.frame = CGRect(x: 10, y: 4, width: imageSize, height: imageSize)
        trackNameLabel.frame = CGRect(x: trackCoverImageView.right + 10,
                                      y: 6,
                                      width: width-20,
                                      height: 20)
        trackOwnerNameLabel.frame = CGRect(x: trackCoverImageView.right + 10,
                                           y: trackNameLabel.bottom + 6, width: width - 20, height: 14)
    }
    
    override func prepareForReuse() {
        trackCoverImageView.image = nil
        trackNameLabel.text = nil
        trackOwnerNameLabel.text = nil
    }
    
    func configure(with viewModel: RecommendedTracksCellViewModel) {
        debugPrint(viewModel)
        if viewModel.artworkURL != nil {
            trackCoverImageView.sd_setImage(with: viewModel.artworkURL)

        }
        trackNameLabel.text = viewModel.name
        trackOwnerNameLabel.text = viewModel.artistName
    }
}
