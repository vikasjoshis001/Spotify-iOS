//
//  TitleHeaderCollectionReusableView.swift
//  Spotify-Clone
//
//  Created by Vikas Joshi on 29/11/24.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = Constants.TITLE_HEADER
    
    private var titleHeaderLabel: UILabel = {
        let titleHeaderLabel = UILabel()
        titleHeaderLabel.textColor = .white
        titleHeaderLabel.numberOfLines = 1
        titleHeaderLabel.font = .systemFont(ofSize: 26, weight: .bold)
        return titleHeaderLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        addSubview(titleHeaderLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleHeaderLabel.frame = CGRect(x: 10, y: 0, width: width - 30, height: height)
    }
    
    override func prepareForReuse() {
        titleHeaderLabel.text = nil
    }
    
    func configure(with title: String) {
        titleHeaderLabel.text = title
    }
}
