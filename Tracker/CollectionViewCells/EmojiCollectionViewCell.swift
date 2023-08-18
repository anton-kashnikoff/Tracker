//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Антон Кашников on 04.08.2023.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "emojiItem"
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
