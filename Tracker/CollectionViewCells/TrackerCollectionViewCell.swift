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
//        view.frame.size = CGSize(width: 24, height: 24)
        view.backgroundColor = UIColor(white: 1, alpha: 0.3)
        view.layer.cornerRadius = 12
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
    
    let completedButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var dataHelper: DataHelper?
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
        guard let tracker, let date, let dataHelper else {
            print("Unable to find tracker and/or date and/or dataHelper for this cell")
            return
        }
        
        let trackerRecord = TrackerRecord(id: tracker.id, date: date)
        
        guard trackerRecord.date <= Calendar.current.startOfDay(for: Date()) else {
            return
        }
        
        let trackerRecordState = dataHelper.checkTrackerRecordForDate(trackerRecord.date, id: trackerRecord.id)
        
        switch trackerRecordState {
        case .existForDate:
            // если listOfDatesForTracker содержит текущую дату, то
            // при нажатии кнопку нужно поменять на плюс, удалить запись для этой даты и поменять текст на актуальное кол-во дат в массиве для этого трекера
            completedButton.setImage(UIImage(named: "Plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
            dataHelper.toggleTrackerRecord(trackerRecord, trackerRecordState: .existForDate)
        case .existForAnotherDate:
            // если listOfDatesForTracker не содержит текущую дату, но содержит какие-то другие даты, то
            // при нажатии поменять кнопку на галочку, сделать запись для этой даты и поменять текст на актуальное кол-во дат в массиве для этого трекера
            completedButton.setImage(UIImage(named: "Tick")?.withRenderingMode(.alwaysTemplate), for: .normal)
            dataHelper.toggleTrackerRecord(trackerRecord, trackerRecordState: .existForAnotherDate)
        case .notExist:
            // если listOfDatesForTracker не содержит ни одной записи для этого трекера, то
            // при нажатии кнопку поменять на галочку, сделать запись для этой даты и поменять текст на актуальное кол-во дат в массиве для этого трекера, то есть 1
            completedButton.setImage(UIImage(named: "Tick")?.withRenderingMode(.alwaysTemplate), for: .normal)
            dataHelper.toggleTrackerRecord(trackerRecord, trackerRecordState: .notExist)
        }
        
        let countOfCompletedDaysForTracker = dataHelper.getCountOfCompletedDaysForTracker(trackerRecord.id) ?? 0
        
        daysCountLabel.text = "\(countOfCompletedDaysForTracker) дней"
    }
}
