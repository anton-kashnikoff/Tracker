//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Антон Кашников on 03.08.2023.
//

import UIKit

final class NewHabitViewController: UIViewController {
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
        textField.placeholder = "Введите название трекера"
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
    
    let emojiCollectionView: UICollectionView = {
        let emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        emojiCollectionView.contentInset = UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        emojiCollectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: EmojiCollectionViewCell.reuseIdentifier)
        return emojiCollectionView
    }()
    
    let emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.text = "Emoji"
        emojiLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        return emojiLabel
    }()
    
    let colorLabel: UILabel = {
        let colorLabel = UILabel()
        colorLabel.text = "Цвет"
        colorLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        return colorLabel
    }()
    
    let colorCollectionView: UICollectionView = {
        let colorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
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
        cancelButton.setTitle("Отменить", for: .normal)
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
        createButton.setTitle("Создать", for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        createButton.setTitleColor(.ypWhite, for: .normal)
        createButton.layer.cornerRadius = 16
        createButton.translatesAutoresizingMaskIntoConstraints = false
        return createButton
    }()
    
    private let tableViewCells = ["Категория", "Расписание"]
    let emoji = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    let colors: [UIColor] = [.colorSelection1, .colorSelection2, .colorSelection3, .colorSelection4, .colorSelection5, .colorSelection6, .colorSelection7, .colorSelection8, .colorSelection9, .colorSelection10, .colorSelection11, .colorSelection12, .colorSelection13, .colorSelection14, .colorSelection15, .colorSelection16, .colorSelection17, .colorSelection18]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        navigationItem.title = "Новая привычка"
        
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
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 841)
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
    
    func setupRestrictionLabel() {
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
            tableView.heightAnchor.constraint(equalToConstant: 150),
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
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
        
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
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
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
            buttonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupCreateButton() {
        buttonsStackView.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            createButton.widthAnchor.constraint(equalToConstant: 161),
            createButton.topAnchor.constraint(equalTo: buttonsStackView.topAnchor),
            createButton.bottomAnchor.constraint(equalTo: buttonsStackView.bottomAnchor),
            createButton.trailingAnchor.constraint(equalTo: buttonsStackView.trailingAnchor)
        ])
    }
    
    private func setupCancelButton() {
        buttonsStackView.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: buttonsStackView.topAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: buttonsStackView.bottomAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            cancelButton.leadingAnchor.constraint(equalTo: buttonsStackView.leadingAnchor)
        ])
    }
    
    func showRestrictionLabel() {
        restrictionLabel.text = "Ограничение 38 символов"
        restrictionLabel.isHidden = false
        setupTableView()
    }
    
    func hideRestrictionLabel() {
        restrictionLabel.text = nil
        restrictionLabel.isHidden = true
        setupTableView()
    }
}

extension NewHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

extension NewHabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "habitCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .ypBackground
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = tableViewCells[indexPath.row]
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = tableViewCells[indexPath.row]
        }
        
        return cell
    }
}

extension NewHabitViewController: UICollectionViewDelegate {

}

extension NewHabitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case emojiCollectionView:
            return emoji.count
        case colorCollectionView:
            return colors.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.reuseIdentifier, for: indexPath) as? EmojiCollectionViewCell else {
                print("Unable to create EmojiCollectionViewCell")
                return UICollectionViewCell()
            }

            cell.label.text = emoji[indexPath.row]
            cell.label.font = UIFont.systemFont(ofSize: 32)
            return cell
        } else if collectionView == colorCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.reuseIdentifier, for: indexPath) as? ColorCollectionViewCell else {
                print("Unable to create ColorCollectionViewCell")
                return UICollectionViewCell()
            }
            
            cell.view.backgroundColor = colors[indexPath.row]
            cell.view.layer.cornerRadius = 8
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension NewHabitViewController: UICollectionViewDelegateFlowLayout {
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
