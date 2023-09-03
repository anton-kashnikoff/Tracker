//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Антон Кашников on 05.08.2023.
//

import UIKit

final class CategoryViewController: UIViewController {
    static let didChangeNotification = Notification.Name(rawValue: "CategoryDidChange")
    
    let imageView: UIImageView = {
        let imageView = UIImageView(image: .star)
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
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = 75
        tableView.layer.cornerRadius = 16
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
//    private let trackerCategoryStore = TrackerCategoryStore()
    private var viewModel = CategoriesViewModel(store: TrackerCategoryStore())
    
    private var categoriesListObserver: NSObjectProtocol?
    private var tableViewHeightConstraint: NSLayoutConstraint?
    
    weak var newTrackerViewController: NewTrackerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        navigationItem.hidesBackButton = true
        navigationItem.title = "Категория"
        
        viewModel.setDelegate(self)
        
        categoriesListObserver = NotificationCenter.default.addObserver(forName: NewCategoryViewController.didChangeNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let self else {
                return
            }
            
            self.imageView.removeFromSuperview()
            self.label.removeFromSuperview()
            self.updateTableViewHeight(to: CGFloat(self.viewModel.numberOfObjects()) * self.tableView.rowHeight)
            self.tableView.reloadData()
        })
        
        
        if viewModel.isFetchedObjectsEmpty() {
            showEmptyView()
        }
        
        setupTableView()
        setupButton()
        
        updateTableViewHeight(to: CGFloat(viewModel.numberOfObjects()) * tableView.rowHeight)
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
        navigationController?.pushViewController(newCategoryViewController, animated: true)
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier, for: indexPath) as? CategoryTableViewCell else {
            print("Unable to create CategoryTableViewCell to select")
            return
        }
        
        cell.checkmarkImageView.isHidden = false
        
        newTrackerViewController?.category = viewModel.getObjectAt(indexPath: indexPath)
        newTrackerViewController?.tryActivateCreateButton()
        
        NotificationCenter.default.post(name: CategoryViewController.didChangeNotification, object: self)
        navigationController?.popViewController(animated: true)
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier, for: indexPath) as? CategoryTableViewCell else {
            print("Unable to create CategoryTableViewCell")
            return UITableViewCell()
        }
        
        let categoryObject = viewModel.getObjectAt(indexPath: indexPath)
        let category = viewModel.makeTrackerCategory(from: categoryObject)
        
        cell.separatorView.isHidden = indexPath.row == viewModel.numberOfObjects() - 1
        cell.titleLabel.text = category?.name
        
        return cell
    }
}

extension CategoryViewController {
    func reloadData() {
        tableView.reloadData()
    }
}
