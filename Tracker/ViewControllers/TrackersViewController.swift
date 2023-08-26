//
//  CollectionViewController.swift
//  Tracker
//
//  Created by Антон Кашников on 28.07.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    let collectionView: TrackersCollectionView = {
        let collectionView = TrackersCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .ypWhite
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier)
        collectionView.register(HeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let barButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.image = .addTrackerIcon
        barButtonItem.tintColor = .ypBlack
        return barButtonItem
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    let searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.placeholder = "Поиск"
        searchTextField.clearButtonMode = .never
        searchTextField.backgroundColor = .searchTextFieldColor
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        return searchTextField
    }()
    
    let searchCancelButton: UIButton = {
        let button = UIButton()
        button.frame.size = CGSize(width: 83, height: 36)
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitleColor(.ypBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let trackerCategoryStore = TrackerCategoryStore()
    let trackerStore = TrackerStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    private var newTrackerObserver: NSObjectProtocol?
    private var constraintToCancelButton: NSLayoutConstraint?
    private var constraintToSuperview: NSLayoutConstraint?
    private var currentText: String?
    var currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissKeyboard()
        
        view.backgroundColor = .ypWhite
        
        currentDate = datePicker.date.withZeroTime
        currentText = searchTextField.text
        
        trackerStore.delegate = self
        trackerRecordStore.delegate = self
        
        newTrackerObserver = NotificationCenter.default.addObserver(forName: NewTrackerViewController.didChangeNotification, object: nil, queue: .main, using: { [weak self] _ in
            self?.reloadData()
        })
        
        setupNavigationBar()
        setupSearchTextField()
        setupCollectionView()
        setupImageView()
        setupLabel()
        
        reloadData()
    }
    
    private func setupNavigationBar() {
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupDatePicker()
        
        barButtonItem.target = self
        barButtonItem.action = #selector(addTracker)
        
        navigationItem.leftBarButtonItem = barButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func setupDatePicker() {
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    private func setupSearchTextField() {
        searchTextField.delegate = self
        view.addSubview(searchTextField)
        
        constraintToSuperview = searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            constraintToSuperview!,
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupSearchCancelButton() {
        searchCancelButton.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
        view.addSubview(searchCancelButton)
        
        NSLayoutConstraint.activate([
            searchCancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchCancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        constraintToSuperview?.isActive = false
        constraintToCancelButton = searchTextField.trailingAnchor.constraint(equalTo: searchCancelButton.leadingAnchor, constant: -5)
        constraintToCancelButton?.isActive = true
        
    }
    
    private func setupCollectionView() {
        collectionView.trackersViewController = self
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 34),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupLabel() {
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func hideCancelButton() {
        searchCancelButton.removeFromSuperview()
        constraintToCancelButton?.isActive = false
        constraintToSuperview?.isActive = true
    }
    
    @objc
    private func addTracker() {
        let trackerTypeViewController = TrackerTypeViewController()
        trackerTypeViewController.trackersViewController = self
        let navigationController = UINavigationController(rootViewController: trackerTypeViewController)
        present(navigationController, animated: true)
    }
    
    @objc
    private func dateChanged() {
        currentDate = datePicker.date.withZeroTime
        reloadData()
    }
    
    @objc
    private func cancelButtonDidTap() {
        searchTextField.text = nil
        currentText = nil
        reloadData()
        hideCancelButton()
    }
    
    private func reloadPlaceholderView() {
        if trackerStore.isFetchedObjectsEmpty() && currentText != "" {
            print("FIRST")
            imageView.image = .nothingFound
            label.text = "Ничего не найдено"
            imageView.isHidden = false
            label.isHidden = false
        } else if trackerStore.isFetchedObjectsEmpty() {
            print("SECOND")
            imageView.image = .star
            label.text = "Что будем отслеживать?"
            imageView.isHidden = false
            label.isHidden = false
        } else {
            print("else")
            imageView.isHidden = true
            label.isHidden = true
        }
    }
}

// MARK: - UITextFieldDelegate

extension TrackersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        hideCancelButton()
        reloadData()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as? NSString {
            currentText = text.replacingCharacters(in: range, with: string)
        }
        reloadData()

        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        setupSearchCancelButton()
        return true
    }
}

extension TrackersViewController {
    func reloadData() {
        let dayOfWeek = Schedule.getNameOfDay(Calendar.current.component(.weekday, from: currentDate))
        let text = currentText ?? ""
        
        if text.isEmpty {
            // фильтруем только по дате
            trackerStore.fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(TrackerCoreData.schedule), dayOfWeek)
        } else {
            // фильтр по дате и тексту
            trackerStore.fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "(%K CONTAINS[cd] %@) AND (%K CONTAINS[cd] %@)", #keyPath(TrackerCoreData.schedule), dayOfWeek, #keyPath(TrackerCoreData.name), text)
        }
        
        do {
            try trackerStore.fetchedResultsController.performFetch()
            try trackerRecordStore.fetchedResultsController.performFetch()
        } catch let error as NSError  {
            print("Error: \(error)")
        }
        
        collectionView.reloadData()
        reloadPlaceholderView()
    }
}
