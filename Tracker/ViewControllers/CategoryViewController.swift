//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Антон Кашников on 05.08.2023.
//

import UIKit

final class CategoryViewController: UIViewController {
    let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "star"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно\nобъединить по смыслу"
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 75
        tableView.layer.cornerRadius = 16
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .ypGray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoryCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var categories = [TrackerCategory]()
    private var categoriesListObserver: NSObjectProtocol?
    var newHabitViewController: NewHabitViewController?
    static let didChangeNotification = Notification.Name(rawValue: "CategoryDidChange")
    var tableViewHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        navigationItem.title = "Категория"
        
        categoriesListObserver = NotificationCenter.default.addObserver(forName: NewCategoryViewController.didChangeNotification, object: nil, queue: .main, using: { [weak self] _ in
            self?.imageView.removeFromSuperview()
            self?.label.removeFromSuperview()
            self?.updateTableViewHeight(to: CGFloat(self?.categories.count ?? 0) * (self?.tableView.rowHeight)!)
            self?.tableView.reloadData()
//            print("Got notification \(self?.categories)")
        })
        
        if categories.isEmpty {
            showEmptyView()
        }
        
        setupTableView()
        setupButton()
    }
    
    private func showEmptyView() {
        setupImageView()
        setupLabel()
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
            label.heightAnchor.constraint(equalToConstant: 36),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupButton() {
        button.addTarget(self, action: #selector(addCategoryButtonDidTap), for: .touchUpInside)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 60),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 75)
        tableViewHeightConstraint?.isActive = true
    }
    
    private func updateTableViewHeight(to height: CGFloat) {
        tableViewHeightConstraint?.constant = height
        view.layoutIfNeeded()
    }
    
    @objc
    private func addCategoryButtonDidTap() {
        let newCategoryViewController = NewCategoryViewController()
        newCategoryViewController.categoryViewController = self
        let navigationController = UINavigationController(rootViewController: newCategoryViewController)
        present(navigationController, animated: true)
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.dequeueReusableCell(withIdentifier: "categoryCell")?.accessoryType = .checkmark
        newHabitViewController?.category = categories[indexPath.row]
        newHabitViewController?.tryActivateCreateButton()
        NotificationCenter.default.post(name: CategoryViewController.didChangeNotification, object: self)
        dismiss(animated: true)
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.backgroundColor = .ypBackground
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = categories[indexPath.row].name
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = categories[indexPath.row].name
        }
        
        return cell
    }
}
