//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Антон Кашников on 06.08.2023.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "trackerItem"
    
    let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.trackerCellBorderColor.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emojiView: UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: 24, height: 24)
        view.backgroundColor = .emojiViewColor
        view.layer.cornerRadius = 68
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let trackerTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .ypWhite
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let quantityManagementView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let daysCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let plusButton: UIButton = {
        let button = UIButton()
        button.frame.size = CGSize(width: 34, height: 34)
        button.layer.cornerRadius = 17
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCardView()
        setupQuantityManagementView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCardView() {
        setupEmojiView()
        setupTrackerTitleLabel()
        
        contentView.addSubview(cardView)
        
        NSLayoutConstraint.activate([
            cardView.heightAnchor.constraint(equalToConstant: 90),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func setupQuantityManagementView() {
        setupDaysCountLabel()
        setupPlusButton()
        contentView.addSubview(quantityManagementView)
        
        NSLayoutConstraint.activate([
            quantityManagementView.topAnchor.constraint(equalTo: cardView.bottomAnchor),
            quantityManagementView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            quantityManagementView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            quantityManagementView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func setupEmojiLabel() {
        emojiView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor)
        ])
    }
    
    private func setupEmojiView() {
        setupEmojiLabel()
        cardView.addSubview(emojiView)
        
        NSLayoutConstraint.activate([
            emojiView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12)
        ])
    }
    
    private func setupTrackerTitleLabel() {
        cardView.addSubview(trackerTitleLabel)
        
        NSLayoutConstraint.activate([
            trackerTitleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            trackerTitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            trackerTitleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12)
        ])
    }
    
    private func setupDaysCountLabel() {
        quantityManagementView.addSubview(daysCountLabel)
        
        NSLayoutConstraint.activate([
            daysCountLabel.topAnchor.constraint(equalTo: quantityManagementView.topAnchor, constant: 16),
            daysCountLabel.leadingAnchor.constraint(equalTo: quantityManagementView.leadingAnchor, constant: 12),
            daysCountLabel.trailingAnchor.constraint(equalTo: quantityManagementView.trailingAnchor, constant: -54)
        ])
    }
    
    private func setupPlusButton() {
        quantityManagementView.addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            plusButton.topAnchor.constraint(equalTo: quantityManagementView.topAnchor, constant: 8),
            plusButton.trailingAnchor.constraint(equalTo: quantityManagementView.trailingAnchor, constant: -12)
        ])
    }
}
