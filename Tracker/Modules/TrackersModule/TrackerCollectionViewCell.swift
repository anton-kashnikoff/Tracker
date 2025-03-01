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
    
    private let emojiView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.3)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let trackerTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let quantityManagementView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let daysCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let completedButton: UIButton = {
        let button = UIButton()
        button.setImage(.plus?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var trackerRecordViewModel: TrackerRecordViewModel?
    var tracker: Tracker?
    var date: Date?
    var isCompleted = false
    
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
        setupCompletedButton()
        contentView.addSubview(quantityManagementView)
        
        NSLayoutConstraint.activate([
            quantityManagementView.topAnchor.constraint(equalTo: cardView.bottomAnchor),
            quantityManagementView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            quantityManagementView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            quantityManagementView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func setupEmojiView() {
        setupEmojiLabel()
        cardView.addSubview(emojiView)
        
        NSLayoutConstraint.activate([
            emojiView.heightAnchor.constraint(equalToConstant: 24),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            emojiView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12)
        ])
    }
    
    private func setupEmojiLabel() {
        emojiView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor)
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
    
    private func setupCompletedButton() {
        completedButton.addTarget(self, action: #selector(completedButtonDidTap), for: .touchUpInside)
        quantityManagementView.addSubview(completedButton)
        
        NSLayoutConstraint.activate([
            completedButton.topAnchor.constraint(equalTo: quantityManagementView.topAnchor, constant: 8),
            completedButton.trailingAnchor.constraint(equalTo: quantityManagementView.trailingAnchor, constant: -12)
        ])
    }
    
    @objc
    private func completedButtonDidTap() {
        guard let tracker, let date else {
            print("Unable to find tracker and/or date for this cell")
            return
        }
        
        let trackerRecord = TrackerRecord(id: tracker.id, date: date)
        
        guard trackerRecord.date <= Calendar.current.startOfDay(for: Date()) else {
            return
        }
        // getting the status for a specific tracker on a specific date
        let trackerRecordState = trackerRecordViewModel?.checkTrackerRecordForDate(trackerRecord.date, id: trackerRecord.id)
        
        switch trackerRecordState {
        case .existForDate:
            // if the database contains the current date for this tracker, then when the button is clicked, we need to change it to plus, delete the entry for this date and change the text to the current number of dates in the array for this tracker.
            completedButton.setImage(.plus?.withRenderingMode(.alwaysTemplate), for: .normal)
            trackerRecordViewModel?.toggleTrackerRecord(trackerRecord, trackerRecordState: .existForDate)
        case .notExist:
            // if the database doesn't contain any records for this tracker, then when we click the checkmark button, make an entry for this date and change the text to the current number of dates in the array for this tracker.
            completedButton.setImage(.tick?.withRenderingMode(.alwaysTemplate), for: .normal)
            trackerRecordViewModel?.toggleTrackerRecord(trackerRecord, trackerRecordState: .notExist)
        case .none:
            break
        }
        
        trackerRecordViewModel?.completeTrackerTapped()
        
        let countOfCompletedDaysForTracker = trackerRecordViewModel?.getCountOfCompletedDaysForTracker(trackerRecord.id) ?? -1
        daysCountLabel.text = String.localizedStringWithFormat(NSLocalizedString("numberOfDays", comment: "Number of days completed for tracker"), countOfCompletedDaysForTracker)
    }
}
