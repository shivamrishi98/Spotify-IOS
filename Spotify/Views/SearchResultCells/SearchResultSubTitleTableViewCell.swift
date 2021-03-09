//
//  SearchResultSubTitleTableViewCell.swift
//  Spotify
//
//  Created by Shivam Rishi on 04/03/21.
//

import UIKit
import SDWebImage



class SearchResultSubTitleTableViewCell: UITableViewCell {

    static let identifier = "SearchResultSubTitleTableViewCell"
    
    private let label:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let subtitleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let iconImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
       return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(label)
        addSubview(subtitleLabel)
        addSubview(iconImageView)
        clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize:CGFloat = height-10
        iconImageView.frame = CGRect(x: 10,
                                     y: 5,
                                     width: imageSize,
                                     height: imageSize)
        let labelHeight = height/2
        label.frame = CGRect(x: iconImageView.right+10,
                             y: 0,
                             width: width-(iconImageView.right+10)-5,
                             height: labelHeight)
        
        subtitleLabel.frame = CGRect(x: iconImageView.right+10,
                                     y: label.bottom,
                                     width: width-(iconImageView.right+10)-5,
                                     height: labelHeight)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        subtitleLabel.text = nil
        iconImageView.image = nil
    }
    
    func configure(with viewModel:SearchResultSubTitleTableViewCellViewModel) {
        label.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        iconImageView.sd_setImage(with: viewModel.imageUrl,
                                  placeholderImage: UIImage(systemName: "photo"),
                                  completed: nil)
    }

}
