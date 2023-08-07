//
//  TrackersCollectionView.swift
//  Tracker
//
//  Created by Антон Кашников on 06.08.2023.
//

import UIKit

final class TrackersCollectionView: UICollectionView {
    var trackersViewController: TrackersViewController?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrackersCollectionView: UICollectionViewDelegate {
    
}

extension TrackersCollectionView: UICollectionViewDelegateFlowLayout {
    
}

extension TrackersCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        trackersViewController?.categories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trackersViewController?.categories[section].trackers.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier, for: indexPath) as? TrackerCollectionViewCell else {
            print("Unable to create TrackerCollectionViewCell")
            return UICollectionViewCell()
        }
        
        cell.cardView.backgroundColor = trackersViewController?.categories[0].trackers[indexPath.row].color
        return cell
    }
}
