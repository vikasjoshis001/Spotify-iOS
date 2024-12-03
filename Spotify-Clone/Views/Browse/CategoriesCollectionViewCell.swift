//
//  CategoriesCollectionViewCell.swift
//  Spotify-Clone
//
//  Created by Vikas Joshi on 28/11/24.
//

import SDWebImage
import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    static let identifier = Constants.CATEGORIES
    
    private var categoryCoverImageView: UIImageView = {
        let categoryCoverImageView = UIImageView()
        categoryCoverImageView.image = UIImage(systemName: "photo")
        categoryCoverImageView.contentMode = .scaleAspectFill
        return categoryCoverImageView
    }()
    
    private var categoryNameLabel: UILabel = {
        let categoryNameLabel = UILabel()
        categoryNameLabel.textColor = UIColor.white
        categoryNameLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        categoryNameLabel.numberOfLines = 0
        return categoryNameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.black
        contentView.clipsToBounds = true
        contentView.addSubview(categoryCoverImageView)
        contentView.addSubview(categoryNameLabel)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        categoryNameLabel.sizeToFit()
        categoryCoverImageView.sizeToFit()
        
        let imageSize = contentView.height - 25
        categoryCoverImageView.frame = CGRect(x: 5,
                                              y: 5,
                                              width: imageSize,
                                              height: imageSize)
        
        categoryNameLabel.frame = CGRect(x: (contentView.width - categoryNameLabel.width) / 2,
                                         y: categoryCoverImageView.bottom + 3,
                                         width: categoryNameLabel.width,
                                         height: categoryNameLabel.height)
    }
    
    override func prepareForReuse() {
        categoryNameLabel.text = nil
        categoryCoverImageView.image = nil
    }
    
    func configure(with viewModel: CategoriesCellViewModel) {
        categoryCoverImageView.sd_setImage(with: viewModel.categoryCoverImageURL)
        categoryNameLabel.text = viewModel.categoryName
    }
}
