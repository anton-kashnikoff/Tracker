//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Антон Кашников on 18/09/2023.
//

import UIKit

final class StatisticsViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .ypWhite
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 90
        tableView.register(StatisticsTableViewCell.self, forCellReuseIdentifier: StatisticsTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
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
    
    private var trackerViewModel: TrackerViewModel
    private var trackerRecordViewModel: TrackerRecordViewModel
    
    init(trackerViewModel: TrackerViewModel, trackerRecordViewModel: TrackerRecordViewModel) {
        self.trackerViewModel = trackerViewModel
        self.trackerRecordViewModel = trackerRecordViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        title = NSLocalizedString("statisticsTitle", comment: "Title for navigation bar of statistics screen")
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupImageView()
        setupLabel()
        setupTableView()
        
        reloadPlaceholderView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        reloadPlaceholderView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 206),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
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
    
    private func reloadPlaceholderView() {
        if getCountOfCompletedTrackers() == 0 {
            imageView.image = .nothingToAnalyze
            label.text = NSLocalizedString("statistics.placeholder.nothingToAnalyze", comment: "Text for placeholder view when nothing to analyze")
            imageView.isHidden = false
            label.isHidden = false
            tableView.isHidden = true
        } else {
            imageView.isHidden = true
            label.isHidden = true
            tableView.isHidden = false
        }
    }
    
    private func getCountOfCompletedTrackers() -> Int {
        trackerViewModel.getAllTrackerIDs().reduce(0) { partialResult, id in
            partialResult + (trackerRecordViewModel.getCountOfCompletedDaysForTracker(id) ?? 0)
        }
    }
}

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsTableViewCell.reuseIdentifier, for: indexPath) as? StatisticsTableViewCell else {
            print("Unable to create StatisticsTableViewCell")
            return UITableViewCell()
        }
        
        cell.numberLabel.text = "\(getCountOfCompletedTrackers())"
        
        return cell
    }
}
