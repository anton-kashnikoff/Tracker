//
//  TrackersCollectionView.swift
//  Tracker
//
//  Created by Антон Кашников on 06.08.2023.
//

import UIKit

final class TrackersCollectionView: UICollectionView {
    var trackersViewController: TrackersViewController?
    let params = GeometricParams(cellCount: 2, leftInset: 0, rightInset: 0, cellSpacing: 9)
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        params.cellSpacing
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let trackersViewController else {
            print("Unable to find TrackersViewController - numberOfSections(in:)")
            return 0
        }
        
        return trackersViewController.trackerStore.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let trackersViewController else {
            print("Unable to find TrackersViewController - collectionView(_:numberOfItemsInSection:)")
            return 0
        }
        
        return trackersViewController.trackerStore.numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("\ncollectionView(_:cellForItemAt:) starts")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier, for: indexPath) as? TrackerCollectionViewCell else {
            print("Unable to create TrackerCollectionViewCell")
            return UICollectionViewCell()
        }
        
        guard let trackersViewController else {
            print("Unable to find TrackersViewController - collectionView(_:cellForItemAt:)")
            return UICollectionViewCell()
        }
        
        let trackerObject = trackersViewController.trackerStore.getObjectAt(indexPath: indexPath)

        guard let tracker = trackersViewController.trackerStore.makeTracker(from: trackerObject) else {
            return UICollectionViewCell()
        }
        
        cell.tracker = tracker
        cell.date = trackersViewController.currentDate
        
        cell.cardView.backgroundColor = tracker.color
        cell.emojiLabel.text = tracker.emoji
        cell.trackerTitleLabel.text = tracker.name
        
        let countOfCompletedDaysForTracker = cell.trackerRecordStore.getCountOfCompletedDaysForTracker(tracker.id)
        
        let trackerRecordState = cell.trackerRecordStore.checkTrackerRecordForDate(trackersViewController.currentDate, id: tracker.id)
        
        switch trackerRecordState {
        case .existForDate:
            // если listOfDatesForTracker содержит текущую дату, то
            // при отображении кнопка-галочка, текст = кол-во дат в массиве для этого трекера
            cell.completedButton.setImage(UIImage(named: "Tick")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        case .existForAnotherDate:
//            // если listOfDatesForTracker не содержит текущую дату, но содержит какие-то другие даты, то
//            // при отображении кнопка-плюсик, текст = кол-во дат в массиве для этого трекера
//            cell.completedButton.setImage(UIImage(named: "Plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        case .notExist:
            // если listOfDatesForTracker не содержит ни одной записи для этого трекера, то
            // при отображении кнопка-плюсик, текст = кол-во дат в массиве для этого трекера, то есть 0
            cell.completedButton.setImage(UIImage(named: "Plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        cell.daysCountLabel.text = "\(countOfCompletedDaysForTracker ?? -1) дней"
        cell.completedButton.tintColor = cell.cardView.backgroundColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? HeaderCollectionView else {
            print("Impossible to create HeaderCollectionView")
            return UICollectionReusableView()
        }
        
        guard let trackersViewController else {
            print("Unable to find TrackersViewController - collectionView(_:viewForSupplementaryElementOfKind:at:)")
            return UICollectionViewCell()
        }
        
        let trackerObject = trackersViewController.trackerStore.getObjectAt(indexPath: indexPath)
        headerView.titleLabel.text = trackerObject.category?.name
        
        return headerView
    }
}
