//
//  ColorCollectionView.swift
//  Tracker
//
//  Created by Антон Кашников on 06.08.2023.
//

import UIKit

final class ColorCollectionView: UICollectionView {
    var newHabitViewController: NewTrackerViewController?
    var selectedColor: String?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ColorCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell else {
            print("Unable to create EmojiCollectionViewCell")
            return
        }
        
        cell.layer.borderColor = cell.view.backgroundColor?.withAlphaComponent(0.3).cgColor
        
        newHabitViewController?.habitTrackerData.color = cell.view.backgroundColor
        newHabitViewController?.tryActivateCreateButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell else {
            print("Unable to create EmojiCollectionViewCell")
            return
        }
        
        cell.layer.borderColor = UIColor.ypWhite.cgColor
    }
}

extension ColorCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        newHabitViewController?.colors.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.reuseIdentifier, for: indexPath) as? ColorCollectionViewCell else {
            print("Unable to create ColorCollectionViewCell")
            return UICollectionViewCell()
        }
        
        let backgroundColor = (newHabitViewController?.colors[indexPath.row])!
        let color = UIColorMarshalling().getHEXString(from: backgroundColor)
        
        cell.layer.cornerRadius = 8
        cell.layer.borderWidth = 3
        cell.view.backgroundColor = newHabitViewController?.colors[indexPath.row]
        cell.view.layer.cornerRadius = 8
        
        if color == selectedColor {
            cell.layer.borderColor = cell.view.backgroundColor?.withAlphaComponent(0.3).cgColor
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        } else {
            cell.layer.borderColor = UIColor.ypWhite.cgColor
        }
        
        return cell
    }
}

extension ColorCollectionView: UICollectionViewDelegateFlowLayout {
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
