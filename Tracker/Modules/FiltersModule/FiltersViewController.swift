//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Антон Кашников on 21/09/2023.
//

import UIKit

final class FiltersViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = 75
        tableView.layer.cornerRadius = 16
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let filters = [NSLocalizedString("filters.allTrackers", comment: "Title for all trackers filter"), NSLocalizedString("filters.trackersForToday", comment: "Title for trackers for today filter"), NSLocalizedString("filters.completedTrackers", comment: "Title for completed trackers filter"), NSLocalizedString("filters.uncompletedTrackers", comment: "Title for uncompleted trackers filter")]
    
    weak var trackersViewController: TrackersViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("filters", comment: "Title for Filters screen")
        view.backgroundColor = .ypWhite
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
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
        
        // по умолчанию выбран фильтр "Трекеры на сегодня"
        if indexPath.row == UserDefaults.standard.integer(forKey: "indexOfSelectedCell") {
            cell.isSelected = true
            cell.checkmarkImageView.isHidden = false
        }
        
        return cell
    }
}

extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.reuseIdentifier, for: indexPath) as? CustomTableViewCell else {
            return
        }
        
        UserDefaults.standard.set(indexPath.row, forKey: "indexOfSelectedCell")
        
        cell.isSelected = true
        cell.checkmarkImageView.isHidden = false
        
        trackersViewController?.reloadData()
        
        dismiss(animated: true)
    }
}
