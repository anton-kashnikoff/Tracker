//
//  EmojiCollectionView.swift
//  Tracker
//
//  Created by Антон Кашников on 06.08.2023.
//

import UIKit

final class EmojiCollectionView: UICollectionView {
    var newHabitViewController: NewHabitViewController?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmojiCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell else {
            print("Unable to create EmojiCollectionViewCell")
            return
        }

        cell.backgroundColor = .ypLightGrey
        
        newHabitViewController?.habitTrackerData.emoji = cell.label.text
        newHabitViewController?.tryActivateCreateButton()
        print(newHabitViewController?.habitTrackerData)

    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
   
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell else {
            print("Unable to create EmojiCollectionViewCell")
            return
        }

        cell.backgroundColor = .ypWhite
       
    }
}

extension EmojiCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        newHabitViewController?.emoji.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.reuseIdentifier, for: indexPath) as? EmojiCollectionViewCell else {
            print("Unable to create EmojiCollectionViewCell")
            return UICollectionViewCell()
        }

        cell.label.text = newHabitViewController?.emoji[indexPath.row]
        cell.label.font = UIFont.systemFont(ofSize: 32)
        cell.layer.cornerRadius = 16
        return cell
    }
}

extension EmojiCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
