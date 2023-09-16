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
    let trackerCategoryViewModel = CategoriesViewModel(store: TrackerCategoryStore())
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func pinItemAt(indexPath: IndexPath) {
        trackersViewController?.trackerViewModel.pinTracker(at: indexPath)
    }
    
    private func editItemAt(indexPath: IndexPath) {
        trackersViewController?.trackerViewModel.editTracker(at: indexPath)
    }
    
    private func removeItem(_ trackerObject: TrackerCoreData) {
        trackersViewController?.trackerViewModel.removeTracker(trackerObject)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 30)
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

// MARK: - UICollectionViewDelegate

extension TrackersCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let trackersViewController, !indexPaths.isEmpty else {
            return nil
        }
        print("contextMenuConfigurationForItemsAt")
        
        let indexPath = indexPaths[0]
        
        var title: String
        var trackerObject: TrackerCoreData
        
        if trackersViewController.trackerViewModel.isPinnedFetchedObjectsEmpty() {
            //значит это по любому не закреплённый трекер
            title = "Закрепить"
            trackerObject = trackersViewController.trackerViewModel.getObjectAt(indexPath: indexPath)
        } else if indexPath.section == 0 {
            // если есть закреплённые трекеры и у этого трекера секция = 0, то он закреплён
            title = "Открепить"
            trackerObject = trackersViewController.trackerViewModel.getPinnedObjectAt(indexPath: indexPath)
        } else {
            // если есть закреплённые трекеры и у этого трекера секция отличная от нуля, то он не закреплён
            title = "Закрепить"
            let newIndexPath = IndexPath(item: indexPath.item, section: indexPath.section - 1)
            trackerObject = trackersViewController.trackerViewModel.getObjectAt(indexPath: newIndexPath)
        }
        
        print("title = \(title)")
        print("indexPath = \(indexPath)")
        print("TRACKERS = \(trackersViewController.trackerViewModel.getAll())")
        
        let pinAction = UIAction(title: title) { [weak self] _ in
            self?.pinItemAt(indexPath: indexPath)
        }
        
        let editAction = UIAction(title: "Редактировать") { [weak self] _ in
            self?.trackersViewController?.openEditFlow(for: trackerObject)
        }
        
        let removeAction = UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
            self?.removeItem(trackerObject)
        }
        
        return UIContextMenuConfiguration(actionProvider: { _ in
            UIMenu(children: [pinAction, editAction, removeAction])
        })
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let trackersViewController else {
            print("Unable to find TrackersViewController - numberOfSections(in:)")
            return 0
        }
        
        return trackersViewController.trackerViewModel.getNumberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let trackersViewController else {
            print("Unable to find TrackersViewController - collectionView(_:numberOfItemsInSection:)")
            return 0
        }
        
        return trackersViewController.trackerViewModel.getNumberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let trackersViewController, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier, for: indexPath) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        print("INDEXPATH of tracker = \(indexPath)")
        let trackerObject = trackersViewController.trackerViewModel.getTrackerObject(at: indexPath)
        
        guard let tracker = trackersViewController.trackerViewModel.makeTracker(from: trackerObject) else {
            return UICollectionViewCell()
        }
        print("tracker = \(tracker)")
        
        cell.trackerRecordViewModel = trackersViewController.trackerRecordViewModel
        cell.tracker = tracker
        cell.date = trackersViewController.currentDate
        
        cell.cardView.backgroundColor = tracker.color
        cell.emojiLabel.text = tracker.emoji
        cell.trackerTitleLabel.text = tracker.name
        
        let countOfCompletedDaysForTracker = cell.trackerRecordViewModel?.getCountOfCompletedDaysForTracker(tracker.id) ?? -1
        
        let trackerRecordState = cell.trackerRecordViewModel?.checkTrackerRecordForDate(trackersViewController.currentDate, id: tracker.id)
        
        switch trackerRecordState {
        case .existForDate:
            // если listOfDatesForTracker содержит текущую дату, то
            // при отображении кнопка-галочка, текст = кол-во дат в массиве для этого трекера
            cell.completedButton.setImage(.tick?.withRenderingMode(.alwaysTemplate), for: .normal)
        case .notExist:
            // если listOfDatesForTracker не содержит ни одной записи для этого трекера, то
            // при отображении кнопка-плюсик, текст = кол-во дат в массиве для этого трекера, то есть 0
            cell.completedButton.setImage(.plus?.withRenderingMode(.alwaysTemplate), for: .normal)
        case .none:
            break
        }
        
        cell.daysCountLabel.text = String.localizedStringWithFormat(NSLocalizedString("numberOfDays", comment: "Number of days completed for tracker"), countOfCompletedDaysForTracker)
        cell.completedButton.tintColor = cell.cardView.backgroundColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let trackersViewController, let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? HeaderCollectionView else {
            return UICollectionReusableView()
        }
        
        headerView.titleLabel.text = trackersViewController.trackerViewModel.getSectionTitle(for: indexPath)
        
        return headerView
    }
}
