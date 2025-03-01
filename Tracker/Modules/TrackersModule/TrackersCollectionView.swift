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
    
    private func removeItem(_ trackerObject: TrackerCoreData) {
        let alertController = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        let message = NSMutableAttributedString(string: NSLocalizedString("confirmationOfDeletion", comment: "Conformation of deletion tracker"))
        message.addAttribute(.font, value: UIFont.systemFont(ofSize: 13), range: NSRange(location: .zero, length: message.length))
        
        alertController.setValue(message, forKey: "attributedMessage")
        alertController.addAction(
            UIAlertAction(title: NSLocalizedString("delete", comment: "Removing of tracker"), style: .destructive) { [weak self] _ in
                self?.trackersViewController?.trackerViewModel.removeTracker(trackerObject)
            }
        )
        alertController.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: "Cancel action"), style: .cancel))
        
        trackersViewController?.trackerViewModel.deleteTrackerTapped()
        
        trackersViewController?.present(alertController, animated: true)
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
        
        let indexPath = indexPaths[0]
        
        var title: String
        var trackerObject: TrackerCoreData
        
        if trackersViewController.trackerViewModel.isPinnedFetchedObjectsEmpty() {
            // it's not a pinned tracker anyway
            title = NSLocalizedString("pin", comment: "Pin tracker action")
            trackerObject = trackersViewController.trackerViewModel.getObjectAt(indexPath: indexPath)
        } else if indexPath.section == 0 {
            // if there are pinned trackers and this tracker has section = 0, then it is pinned
            title = NSLocalizedString("unpin", comment: "unin tracker action")
            trackerObject = trackersViewController.trackerViewModel.getPinnedObjectAt(indexPath: indexPath)
        } else {
            // if there are pinned trackers and this tracker has a section other than zero, then it's not pinned
            title = NSLocalizedString("pin", comment: "Pin tracker action")
            let newIndexPath = IndexPath(item: indexPath.item, section: indexPath.section - 1)
            trackerObject = trackersViewController.trackerViewModel.getObjectAt(indexPath: newIndexPath)
        }
        
        let pinAction = UIAction(title: title) { [weak self] _ in
            self?.pinItemAt(indexPath: indexPath)
        }
        
        let editAction = UIAction(title: NSLocalizedString("edit", comment: "Edit tracker action")) { [weak self] _ in
            self?.trackersViewController?.openEditFlow(for: trackerObject)
        }
        
        let removeAction = UIAction(title: NSLocalizedString("delete", comment: "Removing of tracker action"), attributes: .destructive) { [weak self] _ in
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
            return .zero
        }
        
        return trackersViewController.trackerViewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let trackersViewController else {
            print("Unable to find TrackersViewController - collectionView(_:numberOfItemsInSection:)")
            return .zero
        }
        
        return trackersViewController.trackerViewModel.numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let trackersViewController, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier, for: indexPath) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let trackerObject = trackersViewController.trackerViewModel.getTrackerObject(at: indexPath)
        
        guard let tracker = trackersViewController.trackerViewModel.makeTracker(from: trackerObject) else {
            return UICollectionViewCell()
        }
        
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
            cell.completedButton.setImage(.tick?.withRenderingMode(.alwaysTemplate), for: .normal)
        case .notExist:
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
