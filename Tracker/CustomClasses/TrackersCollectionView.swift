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

extension TrackersCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: section))
//        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
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

extension TrackersCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let trackersViewController else {
            print("Unable to find TrackersViewController - numberOfSections(in:)")
            return 0
        }
        
        return trackersViewController.searchedCategories.isEmpty ? trackersViewController.categoriesToShow.count : trackersViewController.searchedCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let trackersViewController else {
            print("Unable to find TrackersViewController - collectionView(_:,numberOfItemsInSection:)")
            return 0
        }
        
        return trackersViewController.searchedCategories.isEmpty ? trackersViewController.categoriesToShow[section].trackers.count : trackersViewController.searchedCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier, for: indexPath) as? TrackerCollectionViewCell else {
            print("Unable to create TrackerCollectionViewCell")
            return UICollectionViewCell()
        }
        
        guard let trackersViewController else {
            print("Unable to find TrackersViewController - collectionView(_:,cellForItemAt:)")
            return UICollectionViewCell()
        }
        
        let tracker = trackersViewController.searchedCategories.isEmpty ? trackersViewController.categoriesToShow[indexPath.section].trackers[indexPath.row] : trackersViewController.searchedCategories[indexPath.section].trackers[indexPath.row]
        
        cell.dataHelper = DataHelper()
        cell.dataHelper?.trackersViewController = trackersViewController
        cell.tracker = tracker
        cell.date = trackersViewController.currentDate
        
        cell.cardView.backgroundColor = tracker.color
        cell.emojiLabel.text = tracker.emoji
        cell.trackerTitleLabel.text = tracker.name
        
        let countOfCompletedDaysForTracker = cell.dataHelper?.getCountOfCompletedDaysForTracker(tracker.id) ?? 0
        
        guard let trackerRecordState = cell.dataHelper?.checkTrackerRecordForDate(cell.date!, id: tracker.id) else {
            return UICollectionViewCell()
        }
        
        switch trackerRecordState {
        case .existForDate:
            // если listOfDatesForTracker содержит текущую дату, то
            // при отображении кнопка-галочка, текст = кол-во дат в массиве для этого трекера
            cell.completedButton.setImage(UIImage(named: "Tick")?.withRenderingMode(.alwaysTemplate), for: .normal)
        case .existForAnotherDate:
            // если listOfDatesForTracker не содержит текущую дату, но содержит какие-то другие даты, то
            // при отображении кнопка-плюсик, текст = кол-во дат в массиве для этого трекера
            cell.completedButton.setImage(UIImage(named: "Plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        case .notExist:
            // если listOfDatesForTracker не содержит ни одной записи для этого трекера, то
            // при отображении кнопка-плюсик, текст = кол-во дат в массиве для этого трекера, то есть 0
            cell.completedButton.setImage(UIImage(named: "Plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        cell.daysCountLabel.text = "\(countOfCompletedDaysForTracker) дней"
        cell.completedButton.tintColor = cell.cardView.backgroundColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? HeaderCollectionView else {
            print("Impossible to create HeaderCollectionView")
            return UICollectionReusableView()
        }
        
        guard let trackersViewController else {
            print("Unable to find TrackersViewController - collectionView(_:,viewForSupplementaryElementOfKind:, at:)")
            return UICollectionViewCell()
        }
        headerView.backgroundColor = .brown
        
        headerView.titleLabel.text = trackersViewController.searchedCategories.isEmpty ? trackersViewController.categoriesToShow[indexPath.section].name : trackersViewController.searchedCategories[indexPath.section].name
        
        return headerView
    }
}
