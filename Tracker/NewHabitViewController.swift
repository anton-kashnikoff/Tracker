//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Антон Кашников on 03.08.2023.
//

import UIKit

final class NewHabitViewController: UIViewController {
    let textField: TextField = {
        let textField = TextField()
        textField.placeholder = "Введите название трекера"
        textField.layer.cornerRadius = 16
        textField.backgroundColor = .ypBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
        emojiCollectionView.backgroundColor = .red
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
        colorCollectionView.backgroundColor = .blue
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        colorCollectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: ColorCollectionViewCell.reuseIdentifier)
        return colorCollectionView
    }()
    
    private let tableViewCells = ["Категория", "Расписание"]
    let emoji = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    let colors: [UIColor] = [.colorSelection1, .colorSelection2, .colorSelection3, .colorSelection4, .colorSelection5, .colorSelection6, .colorSelection7, .colorSelection8, .colorSelection9, .colorSelection10, .colorSelection11, .colorSelection12, .colorSelection13, .colorSelection14, .colorSelection15, .colorSelection16, .colorSelection17, .colorSelection18]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        navigationItem.title = "Новая привычка"
        
        setupTextField()
        setupTableView()
        setupEmojiLabel()
        setupEmojiCollectionView()
        setupColorLabel()
        setupColorCollectionView()
    }
    
    private func setupTextField() {
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupEmojiLabel() {
        view.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.heightAnchor.constraint(equalToConstant: 18),
            emojiLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            emojiLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            emojiLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: 295)
        ])
    }
    
    private func setupEmojiCollectionView() {
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
        
        view.addSubview(emojiCollectionView)
        
        NSLayoutConstraint.activate([
            emojiCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 204),
            emojiCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func setupColorLabel() {
        view.addSubview(colorLabel)
        
        NSLayoutConstraint.activate([
            colorLabel.heightAnchor.constraint(equalToConstant: 18),
            colorLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
            colorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            colorLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: 295)
        ])
    }
    
    private func setupColorCollectionView() {
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        view.addSubview(colorCollectionView)
        
        NSLayoutConstraint.activate([
            colorCollectionView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 204),
            colorCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            colorCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
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
