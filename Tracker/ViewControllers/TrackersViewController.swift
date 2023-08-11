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
        searchTextField.backgroundColor = .searchTextFieldColor
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        return searchTextField
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
    var categories = [TrackerCategory]()
    var currentDate = Date()
    var dataHelper: DataHelper?
    var categoriesToShow = [TrackerCategory]()
    var searchedCategories = [TrackerCategory]()
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
                Tracker(id: UUID(), name: "Rose", color: .colorSelection10, emoji: "💗", schedule: Schedule(daysOfWeek: [.tuesday, .saturday]))
            ]),
            TrackerCategory(name: "Rir", trackers: [
                Tracker(id: UUID(), name: "Valery", color: .colorSelection1, emoji: "🩷", schedule: Schedule(daysOfWeek: [.sunday])),
                Tracker(id: UUID(), name: "Inna", color: .colorSelection1, emoji: "💚", schedule: Schedule(daysOfWeek: [.thursday]))
            ])
        ]
        
        currentDate = datePicker.date.withRemovedTime
        
        dataHelper = DataHelper()
        dataHelper?.trackersViewController = self
        
        newTrackerObserver = NotificationCenter.default.addObserver(forName: NewHabitViewController.didChangeNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let self else {
                return
            }
            
            self.showTrackersForDate(self.currentDate)
        })
        
        setupNavigationBar()
        setupSearchTextField()
        setupCollectionView()
        showTrackersForDate(currentDate)
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
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    private func setupSearchTextField() {
        searchTextField.delegate = self
        view.addSubview(searchTextField)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
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
    
    private func setupEmptyView(for emptyViewCase: EmptyViewCase) {
        switch emptyViewCase {
        case .noTrackersForDate:
            setupImageView(with: UIImage(named: "star"))
            setupLabel(with: "Что будем отслеживать?")
        case .nothingFound:
            setupImageView(with: UIImage(named: "NothingFound"))
            setupLabel(with: "Ничего не найдено")
        }
    }
    
    private func removeEmptyView() {
        imageView.removeFromSuperview()
        label.removeFromSuperview()
    }
    
    private func setupImageView(with image: UIImage?) {
        imageView.image = image
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNothingFoundImage() {
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupLabel(with text: String) {
        label.text = text
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func showTrackersForDate(_ date: Date) {
        dataHelper?.fillArray(for: date)
        
        showTrackers(array: categoriesToShow, emptyViewCase: EmptyViewCase.noTrackersForDate)
    }
    
    private func showSearchedTrackers(for text: String) {        
        dataHelper?.fillArray(for: text)
        
        showTrackers(array: searchedCategories, emptyViewCase: EmptyViewCase.nothingFound)
    }
    
    private func showTrackers(array: [TrackerCategory], emptyViewCase: EmptyViewCase) {
        if array.isEmpty {
            collectionView.removeFromSuperview()
            setupEmptyView(for: emptyViewCase)
        } else {
            removeEmptyView()
            setupCollectionView()
            collectionView.reloadData()
        }
    }
    
    @objc
    private func addTracker() {
        let trackerTypeViewController = TrackerTypeViewController()
        trackerTypeViewController.trackersViewController = self
        let navigationController = UINavigationController(rootViewController: trackerTypeViewController)
        present(navigationController, animated: true)
    }
    
    @objc
    private func dateChanged(_ sender: UIDatePicker) {
        let date = sender.date.withRemovedTime
        currentDate = date
        showTrackersForDate(date)
    }
}

extension TrackersViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            searchedCategories.removeAll()
            showTrackersForDate(currentDate)
            return true
        }
        
        if let text = textField.text {
            showSearchedTrackers(for: text + string)
        }
        
        return true
    }
}
