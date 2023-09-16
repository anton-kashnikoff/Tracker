//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Антон Кашников on 03.08.2023.
//

import UIKit

final class NewTrackerViewController: UIViewController {
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    let textField: TextField = {
        let textField = TextField()
        textField.identifier = "newHabit"
        textField.placeholder = NSLocalizedString("newTracker.textField.placeholder", comment: "Placeholder tezxt for text field on new tracker screen")
        textField.clearButtonMode = .whileEditing
        textField.layer.cornerRadius = 16
        textField.backgroundColor = .ypBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let restrictionLabel: UILabel = {
        let restrictionLabel = UILabel()
        restrictionLabel.isHidden = true
        restrictionLabel.textAlignment = .center
        restrictionLabel.textColor = .ypRed
        restrictionLabel.translatesAutoresizingMaskIntoConstraints = false
        return restrictionLabel
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 16
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .ypGray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "habitCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let emojiCollectionView: EmojiCollectionView = {
        let emojiCollectionView = EmojiCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        emojiCollectionView.contentInset = UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        emojiCollectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: EmojiCollectionViewCell.reuseIdentifier)
        return emojiCollectionView
    }()
    
    let emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.text = NSLocalizedString("newTracker.emojiLabel.title", comment: "Title for emoji collection")
        emojiLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        return emojiLabel
    }()
    
    let colorLabel: UILabel = {
        let colorLabel = UILabel()
        colorLabel.text = NSLocalizedString("newTracker.colorLabel.title", comment: "Title for color collection")
        colorLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        return colorLabel
    }()
    
    let colorCollectionView: ColorCollectionView = {
        let colorCollectionView = ColorCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        colorCollectionView.contentInset = UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        colorCollectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: ColorCollectionViewCell.reuseIdentifier)
        return colorCollectionView
    }()
    
    let buttonsStackView: UIStackView = {
        let buttonsStackView = UIStackView()
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        return buttonsStackView
    }()
    
    let cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.backgroundColor = .ypWhite
        cancelButton.setTitle(NSLocalizedString("cancel", comment: "Cancel title"), for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.layer.cornerRadius = 16
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        return cancelButton
    }()
    
    let createButton: UIButton = {
        let createButton = UIButton()
        createButton.backgroundColor = .ypGray
        createButton.setTitle(NSLocalizedString("create", comment: "Create title"), for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        createButton.setTitleColor(.ypWhite, for: .normal)
        createButton.layer.cornerRadius = 16
        createButton.translatesAutoresizingMaskIntoConstraints = false
        return createButton
    }()
    
    let emoji = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    let colors: [UIColor] = [.colorSelection1, .colorSelection2, .colorSelection3, .colorSelection4, .colorSelection5, .colorSelection6, .colorSelection7, .colorSelection8, .colorSelection9, .colorSelection10, .colorSelection11, .colorSelection12, .colorSelection13, .colorSelection14, .colorSelection15, .colorSelection16, .colorSelection17, .colorSelection18]
    
    private let trackerType: TrackerType
    private let mode: NewTrackerMode
    
    var habitTrackerData: (id: UUID?, name: String?, color: UIColor?, emoji: String?, schedule: Schedule?)
    var daysOfWeek = [(Int, Schedule.DayOfWeek, Bool)]()
    var category: TrackerCategoryCoreData?
    var trackerObjectInfo: TrackerCoreData?
    var trackerViewModel: TrackerViewModel?
    
    weak var trackersViewController: TrackersViewController?
    
    private var tableViewCells = [String]()
    
    init(trackerType: TrackerType, mode: NewTrackerMode) {
        self.trackerType = trackerType
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
        
        switch trackerType {
        case .habit:
            tableViewCells = [NSLocalizedString("category", comment: "Category title for table cell"), NSLocalizedString("schedule", comment: "Schedule title for table cell")]
        case .irregularEvent:
            tableViewCells = [NSLocalizedString("category", comment: "Category title for table cell")]
        }
        
        for i in 0...6 {
            daysOfWeek.append((i, Schedule.DayOfWeek.allCases[i], false))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissKeyboard()
        
        view.backgroundColor = .ypWhite
        
        navigationItem.hidesBackButton = true
        
        setupScrollView()
        setupContentView()
        setupTextField()
        setupRestrictionLabel()
        setupTableView()
        setupEmojiLabel()
        setupEmojiCollectionView()
        setupColorLabel()
        setupColorCollectionView()
        setupButtonsStackView()
        setupCreateButton()
        setupCancelButton()
        
        switch mode {
        case .create:
            navigationItem.title = NSLocalizedString("newTracker.navigationItem.title", comment: "Title for new tracker screen")
        case .edit:
            navigationItem.title = "Редактирование привычки"
            turnEditMode(for: trackerObjectInfo!)
            trackerViewModel?.removeTracker(trackerObjectInfo!)
        }
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupContentView() {
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
    
    private func setupTextField() {
        textField.newHabitViewController = self
        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupRestrictionLabel() {
        contentView.addSubview(restrictionLabel)
        
        NSLayoutConstraint.activate([
            restrictionLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            restrictionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44),
            restrictionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -45)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        contentView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: restrictionLabel.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(tableViewCells.count * 75)),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupEmojiLabel() {
        contentView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.heightAnchor.constraint(equalToConstant: 18),
            emojiLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            emojiLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: 295)
        ])
    }
    
    private func setupEmojiCollectionView() {
        emojiCollectionView.newHabitViewController = self
        contentView.addSubview(emojiCollectionView)
        
        NSLayoutConstraint.activate([
            emojiCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 204),
            emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    private func setupColorLabel() {
        contentView.addSubview(colorLabel)
        
        NSLayoutConstraint.activate([
            colorLabel.heightAnchor.constraint(equalToConstant: 18),
            colorLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
            colorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            colorLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: 295)
        ])
    }
    
    private func setupColorCollectionView() {
        colorCollectionView.newHabitViewController = self
        contentView.addSubview(colorCollectionView)
        
        NSLayoutConstraint.activate([
            colorCollectionView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 204),
            colorCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func setupButtonsStackView() {
        contentView.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
            buttonsStackView.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 16),
            buttonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupCreateButton() {
        createButton.addTarget(self, action: #selector(createButtonDidTap), for: .touchUpInside)
        buttonsStackView.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            createButton.widthAnchor.constraint(equalToConstant: 161),
            createButton.topAnchor.constraint(equalTo: buttonsStackView.topAnchor),
            createButton.bottomAnchor.constraint(equalTo: buttonsStackView.bottomAnchor),
            createButton.trailingAnchor.constraint(equalTo: buttonsStackView.trailingAnchor)
        ])
    }
    
    private func setupCancelButton() {
        cancelButton.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
        buttonsStackView.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: buttonsStackView.topAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: buttonsStackView.bottomAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            cancelButton.leadingAnchor.constraint(equalTo: buttonsStackView.leadingAnchor)
        ])
    }
    
    private func getDaysOfWeekString() -> String {
        var selectedDays = [String]()
        
        for (_, day, isSelected) in daysOfWeek {
            if isSelected {
                selectedDays.append(day.getBriefDayOfWeek())
            }
        }
        
        return selectedDays.count == 7 ? NSLocalizedString("newTracker.schedule.everyDay", comment: "String for all selected days of week") : selectedDays.joined(separator: ", ")
    }
    
    private var isDataForTrackerReady: Bool {
        switch trackerType {
        case .habit:
            return habitTrackerData.name != nil && habitTrackerData.emoji != nil && habitTrackerData.color != nil && habitTrackerData.schedule != nil && category?.name != nil
        case .irregularEvent:
            return habitTrackerData.name != nil && habitTrackerData.emoji != nil && habitTrackerData.color != nil && category?.name != nil
        }
    }
    
    func turnEditMode(for trackerObject: TrackerCoreData) {
        guard let tracker = trackerViewModel?.makeTracker(from: trackerObject) else {
            return
        }
        
        habitTrackerData.id = tracker.id
        
        textField.text = tracker.name
        habitTrackerData.name = tracker.name
        
        category = trackerObject.category

        let trackerDaysOfWeek = tracker.schedule.daysOfWeek // Set(.monday, .wednesday, .friday)
        
        var array = [(Int, Schedule.DayOfWeek, Bool)]()
        
        for dayCase in Schedule.DayOfWeek.allCases {
            array.append((dayCase.getIndexOfCase(), dayCase, trackerDaysOfWeek.contains(dayCase)))
        }
        
        daysOfWeek = array
        habitTrackerData.schedule = Schedule(daysOfWeek: trackerDaysOfWeek)
        
        emojiCollectionView.selectedEmoji = tracker.emoji
        habitTrackerData.emoji = emojiCollectionView.selectedEmoji
        colorCollectionView.selectedColor = trackerObject.color
        habitTrackerData.color = tracker.color
        print(habitTrackerData)
        tryActivateCreateButton()
    }
    
    @objc
    private func createButtonDidTap() {
        if habitTrackerData.id == nil {
            habitTrackerData.id = UUID()
        }
        
        guard let id = habitTrackerData.id, let name = habitTrackerData.name, let color = habitTrackerData.color, let emoji = habitTrackerData.emoji, let schedule = habitTrackerData.schedule, let category = category else {
            print("Not all data exists")
            return
        }
        
        let tracker = Tracker(id: id, name: name, color: color, emoji: emoji, schedule: schedule)
        trackersViewController?.trackerViewModel.addNewTracker(tracker, to: category)
        dismiss(animated: true)
    }
    
    @objc
    private func cancelButtonDidTap() {
        dismiss(animated: true)
    }
    
    func showRestrictionLabel() {
        restrictionLabel.text = NSLocalizedString("newTracker.restrictionLabel.title", comment: "Text for restriction label")
        restrictionLabel.isHidden = false
        setupTableView()
    }
    
    func hideRestrictionLabel() {
        restrictionLabel.text = nil
        restrictionLabel.isHidden = true
        setupTableView()
    }
    
    func tryActivateCreateButton() {
        createButton.backgroundColor = isDataForTrackerReady ? .ypBlack : .ypGray
    }
}

extension NewTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let categoryViewController = CategoryViewController()
            categoryViewController.newTrackerViewController = self
            
            trackerViewModel?.onCategoryChange = { [weak self] in
                self?.tryActivateCreateButton()
                self?.tableView.reloadData()
            }
            
            navigationController?.pushViewController(categoryViewController, animated: true)
        } else if indexPath.row == 1 {
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.newTrackerViewController = self
            
            trackerViewModel?.onScheduleChange = { [weak self] in
                guard let self else {
                    return
                }
                
                var selectedDays = Set<Schedule.DayOfWeek>()
                
                for (_, day, isSelected) in self.daysOfWeek {
                    if isSelected {
                        selectedDays.insert(day)
                    }
                }
                
                self.habitTrackerData.schedule = Schedule(daysOfWeek: selectedDays)
                self.tryActivateCreateButton()
                self.tableView.reloadData()
            }
            
            navigationController?.pushViewController(scheduleViewController, animated: true)
        }
    }
}

extension NewTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "habitCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .ypBackground
        
        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        
        if indexPath.row == 1 {
            cell.separatorInset = edgeInsets
        } else if tableViewCells.count == 1 {
            cell.separatorInset = edgeInsets
        }
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = tableViewCells[indexPath.row]
            
            if tableViewCells[indexPath.row] == NSLocalizedString("category", comment: "Category title for table cell") {
                content.secondaryText = category?.name
            } else if tableViewCells[indexPath.row] == NSLocalizedString("schedule", comment: "Schedule title for table cell") {
                content.secondaryText = getDaysOfWeekString()
            }
            
            content.secondaryTextProperties.font = UIFont.systemFont(ofSize: 17)
            content.secondaryTextProperties.color = .ypGray
            
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = tableViewCells[indexPath.row]
            if tableViewCells[indexPath.row] == NSLocalizedString("category", comment: "Category title for table cell") {
                cell.detailTextLabel?.text = category?.name
            } else if tableViewCells[indexPath.row] == NSLocalizedString("schedule", comment: "Schedule title for table cell") {
                cell.detailTextLabel?.text = getDaysOfWeekString()
            }
            
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            cell.detailTextLabel?.textColor = .ypGray
        }
        
        return cell
    }
}
