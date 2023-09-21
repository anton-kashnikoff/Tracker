//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Антон Кашников on 21/09/2023.
//

import UIKit

final class FiltersViewController: UIViewController {
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = 75
        tableView.layer.cornerRadius = 16
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let filters = ["Все трекеры", "Трекеры на сегодня", "Завершенные", "Не завершенные"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Фильтры"
        view.backgroundColor = .ypWhite
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalToConstant: tableView.rowHeight * CGFloat(filters.count)),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.reuseIdentifier, for: indexPath) as? CustomTableViewCell else {
            print("Unable to create CustomTableViewCell")
            return UITableViewCell()
        }
        
        cell.separatorView.isHidden = indexPath.row == filters.count - 1
        cell.titleLabel.text = filters[indexPath.row]
        
        return cell
    }
}
