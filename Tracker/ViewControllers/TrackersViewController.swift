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
        barButtonItem.image = UIImage(named: "Add tracker icon")
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
    
    private var newTrackerObserver: NSObjectProtocol?
    private var constraintToCancelButton: NSLayoutConstraint?
    private var constraintToSuperview: NSLayoutConstraint?
    
    var categories = [TrackerCategory]()
    var visibleCategories = [TrackerCategory]()
    
    var dataHelper: DataHelper?
    var currentDate = Date()
    var datesForCompletedTrackers = [UUID:[Date]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissKeyboard()
        
        view.backgroundColor = .ypWhite
        
        categories = [
            TrackerCategory(name: "Pop", trackers: [
                Tracker(id: UUID(), name: "Anton", color: .colorSelection12, emoji: "🧡", schedule: Schedule(daysOfWeek: [.friday])),
                Tracker(id: UUID(), name: "Viktor", color: .colorSelection12, emoji: "💕", schedule: Schedule(daysOfWeek: [.friday]))
            ]),
            TrackerCategory(name: "Lol", trackers: [
                Tracker(id: UUID(), name: "Roman", color: .colorSelection11, emoji: "🤍", schedule: Schedule(daysOfWeek: [.monday]))
            ]),
            TrackerCategory(name: "Vov", trackers: [
                Tracker(id: UUID(), name: "Anna", color: .colorSelection10, emoji: "💙", schedule: Schedule(daysOfWeek: [.wednesday, .friday])),
                Tracker(id: UUID(), name: "Rose", color: .colorSelection10, emoji: "💗", schedule: Schedule(daysOfWeek: [.tuesday, .monday]))
            ]),
            TrackerCategory(name: "Rir", trackers: [
                Tracker(id: UUID(), name: "Valery", color: .colorSelection1, emoji: "🩷", schedule: Schedule(daysOfWeek: [.sunday])),
                Tracker(id: UUID(), name: "Inna", color: .colorSelection1, emoji: "💚", schedule: Schedule(daysOfWeek: [.thursday]))
            ])
        ]
        
        currentDate = datePicker.date.withZeroTime
        
        dataHelper = DataHelper()
        dataHelper?.trackersViewController = self
        
        newTrackerObserver = NotificationCenter.default.addObserver(forName: NewHabitViewController.didChangeNotification, object: nil, queue: .main, using: { [weak self] _ in
            self?.reloadVisibleCategories(with: self?.searchTextField.text)
        })
        
        setupNavigationBar()
        setupSearchTextField()
        setupCollectionView()
        setupImageView()
        setupLabel()
        
        reloadVisibleCategories(with: searchTextField.text)
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
        
        reloadVisibleCategories(with: searchTextField.text)
    }
    
    @objc
    private func cancelButtonDidTap() {
        searchTextField.text = nil
        reloadVisibleCategories(with: searchTextField.text)
        
        hideCancelButton()
    }
    
    private func reloadVisibleCategories(with text: String?) {
        let dayOfWeekFromDatePicker = Calendar.current.component(.weekday, from: datePicker.date)
        let filterText = (text ?? "").lowercased()
        print("FILTER TEXT")
        print(filterText)
        
        visibleCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let textCondition = filterText.isEmpty || tracker.name.lowercased().contains(filterText)
                let dateCondition = tracker.schedule.daysOfWeek.contains { dayOfWeek in
                    dayOfWeek.getNumberOfDay() == dayOfWeekFromDatePicker
                }
                
                return textCondition && dateCondition
            }
            
            if trackers.isEmpty {
                return nil
            }
            
            return  TrackerCategory(name: category.name, trackers: trackers)
        }
        
        collectionView.reloadData()
        reloadPlaceholderView()
    }
    
    private func reloadPlaceholderView() {
        if categories.isEmpty {
            imageView.image = UIImage(named: "star")
            label.text = "Что будем отслеживать?"
            imageView.isHidden = false
            label.isHidden = false
        } else if !categories.isEmpty && visibleCategories.isEmpty {
            imageView.image = UIImage(named: "NothingFound")
            label.text = "Ничего не найдено"
            imageView.isHidden = false
            label.isHidden = false
        } else {
            imageView.isHidden = true
            label.isHidden = true
        }
    }
}

extension TrackersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        hideCancelButton()
        reloadVisibleCategories(with: searchTextField.text)
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            reloadVisibleCategories(with: nil)
        } else {
            reloadVisibleCategories(with: (textField.text ?? "") + string)
        }

        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        setupSearchCancelButton()
        return true
    }
}
