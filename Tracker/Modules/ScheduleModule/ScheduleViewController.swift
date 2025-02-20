//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Антон Кашников on 05.08.2023.
//

import UIKit

final class ScheduleViewController: UIViewController {
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.rowHeight = 75
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .none
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.setTitle(NSLocalizedString("done", comment: "Title for button on Schedule screen"), for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var newTrackerViewController: NewTrackerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        navigationItem.hidesBackButton = true
        navigationItem.title = NSLocalizedString("schedule", comment: "Title for Schedule screen")
        
        setupTableView()
        setupButton()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalToConstant: 525),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupButton() {
        button.addTarget(self, action: #selector(doneButtonDidTap), for: .touchUpInside)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 60),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func getSwitch(for indexPath: IndexPath) -> UISwitch {
        let switchView = UISwitch(frame: .zero)
        let index = indexPath.row
        
        guard let newTrackerViewController else {
            return UISwitch(frame: .zero)
        }
        
        var isDayOfWeekSelected = false
        
        do {
            isDayOfWeekSelected = try newTrackerViewController.dataHelper.getDayOfWeek(index).isSelected
        } catch {
            print("Unable to get day of week")
        }
        
        switchView.setOn(isDayOfWeekSelected, animated: false)
        switchView.onTintColor = .ypBlue
        switchView.tag = index
        switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        return switchView
    }
    
    @objc
    private func doneButtonDidTap() {
        newTrackerViewController?.trackerViewModel?.scheduleSelected()
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func switchChanged(_ sender: UISwitch) {
        newTrackerViewController?.dataHelper.addDayOfWeek(index: sender.tag, isSelected: sender.isOn)
    }
}

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.reuseIdentifier, for: indexPath) as? ScheduleTableViewCell else {
            return UITableViewCell()
        }
        
        cell.backgroundColor = .ypBackground
        cell.accessoryView = getSwitch(for: indexPath)
        
        cell.separatorView.isHidden = indexPath.row == 6
        cell.titleLabel.text = Schedule.DayOfWeek.allCases[indexPath.row].rawValue
        
        return cell
    }
}
