//
//  CollectionViewController.swift
//  Tracker
//
//  Created by Антон Кашников on 28.07.2023.
//

import UIKit

final class CollectionViewController: UIViewController {
    var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = getAddTrackerButtonItem()
        navigationItem.rightBarButtonItem = getDatePickerItem()
    }
    
    private func getAddTrackerButtonItem() -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.image = UIImage(named: "Add tracker icon")
        barButtonItem.tintColor = .black
        barButtonItem.action = #selector(addTracker)
        return barButtonItem
    }
    
    private func getDatePickerItem() -> UIBarButtonItem {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        
        let barButtonItem = UIBarButtonItem(customView: datePicker)
        return barButtonItem
    }
    
    @objc
    private func addTracker() {
        
    }
}

extension CollectionViewController: UICollectionViewDelegate {
    
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
}
