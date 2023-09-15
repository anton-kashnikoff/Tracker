//
//  CollectionViewController.swift
//  Tracker
//
//  Created by Антон Кашников on 28.07.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    private let collectionView: TrackersCollectionView = {
        let collectionView = TrackersCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .ypWhite
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier)
        collectionView.register(HeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let barButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.image = .addTrackerIcon
        barButtonItem.tintColor = .ypBlack
        return barButtonItem
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    private let searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.placeholder = NSLocalizedString("search", comment: "Search text field placeholder")
        searchTextField.clearButtonMode = .never
        searchTextField.backgroundColor = .searchTextFieldColor
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        return searchTextField
    }()
    
    private let searchCancelButton: UIButton = {
        let button = UIButton()
        button.frame.size = CGSize(width: 83, height: 36)
        button.setTitle(NSLocalizedString("cancel", comment: "Search cancel button title"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitleColor(.ypBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var constraintToCancelButton: NSLayoutConstraint?
    private var constraintToSuperview: NSLayoutConstraint?
    private var currentText: String?
    
    var currentDate = Date()
    var trackerViewModel = TrackerViewModel(store: TrackerStore())
    var trackerRecordViewModel = TrackerRecordViewModel(store: TrackerRecordStore())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissKeyboard()
        
        view.backgroundColor = .ypWhite
        
        currentDate = datePicker.date.withZeroTime
        currentText = searchTextField.text
        
        trackerViewModel.setDelegate(self)
        
        setupNavigationBar()
        setupSearchTextField()
        setupCollectionView()
        setupImageView()
        setupLabel()
        
        reloadData()
    }
    
    private func setupNavigationBar() {
        title = NSLocalizedString("trackersTitle", comment: "Title for navigation bar")
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
    
    private func reloadPlaceholderView() {
        if trackerViewModel.isFetchedObjectsEmpty() && currentText != "" {
            imageView.image = .nothingFound
            label.text = NSLocalizedString("trackers.placeholder.nothingFound", comment: "Text for placeholder view when nothing found")
            imageView.isHidden = false
            label.isHidden = false
        } else if trackerViewModel.isFetchedObjectsEmpty() {
            imageView.image = .star
            label.text = NSLocalizedString("trackers.placeholder.noTrackers", comment: "Text for placeholder view when no trackers created")
            imageView.isHidden = false
            label.isHidden = false
        } else {
            imageView.isHidden = true
            label.isHidden = true
        }
    }
    
    @objc
    private func addTracker() {
        let trackerTypeViewController = TrackerTypeViewController()
        trackerTypeViewController.trackersViewController = self
        
        trackerViewModel.onTrackerChange = { [weak self] in
            self?.reloadData()
        }
        
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
        
        trackerViewModel.setPredicate()
        trackerViewModel.setPredicate(date: dayOfWeek, text: text)
        
        do {
            try trackerViewModel.performFetch()
            try trackerRecordViewModel.performFetch()
        } catch let error as NSError  {
            print("Error: \(error)")
        }
        
        collectionView.reloadData()
        reloadPlaceholderView()
    }
}
