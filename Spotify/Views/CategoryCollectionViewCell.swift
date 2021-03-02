//
//  CategoryCollectionViewCell.swift
//  Spotify
//
//  Created by Shivam Rishi on 01/03/21.
//

import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    
    private let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "music.quarternote.3",
                                  withConfiguration: UIImage.SymbolConfiguration(pointSize: 44,
                                                                                 weight: .regular))
        return imageView
    }()
    
    private let label:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 4
        layer.masksToBounds = true
        addSubview(imageView)
        addSubview(label)
    }
    
    private var colors: [UIColor] = [
        .systemPink,
        .systemBlue,
        .systemPurple,
        .systemOrange,
        .systemGreen,
        .systemRed,
        .systemYellow,
        .darkGray,
        .systemTeal
    ]
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        imageView.image = UIImage(systemName: "music.quarternote.3",
                                  withConfiguration: UIImage.SymbolConfiguration(pointSize: 44,
                                                                                 weight: .regular))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 10,
                             y: height/2,
                             width: width-20,
                             height: height/2)
        imageView.frame = CGRect(x: width/2+15,
                                 y: 25,
                                 width: width/2-35,
                                 height: height/2-35)
    }
    
    func configure(with viewModel:CategoryCollectionViewCellViewModel) {
        label.text = viewModel.title
        imageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        backgroundColor = colors.randomElement()
    }
}
