//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Антон Кашников on 05.08.2023.
//

import UIKit

final class ScheduleViewController: UIViewController {
//    static let didChangeNotification = Notification.Name(rawValue: "ScheduleDidChange")
    
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
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var selectedDays: Set<Schedule.DayOfWeek> = []
    
    weak var newTrackerViewController: NewTrackerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        navigationItem.hidesBackButton = true
        navigationItem.title = "Расписание"
        
        setupTableView()
        setupButton()
    }
    
    func setupTableView() {
        tableView.delegate = self
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
        switchView.setOn(false, animated: true)
        switchView.onTintColor = .ypBlue
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        return switchView
    }
    
    @objc
    private func doneButtonDidTap() {
        newTrackerViewController?.trackerViewModel?.scheduleSelected()
//        NotificationCenter.default.post(name: ScheduleViewController.didChangeNotification, object: self)
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func switchChanged(_ sender: UISwitch) {
        let index = sender.tag
        if sender.isOn {
            selectedDays.insert(Schedule.DayOfWeek.allCases[index])
        }
        
        newTrackerViewController?.daysOfWeek.append((index, Schedule.DayOfWeek.allCases[index].getBriefDayOfWeek(), sender.isOn))
        newTrackerViewController?.habitTrackerData.schedule = Schedule(daysOfWeek: selectedDays)
        newTrackerViewController?.tryActivateCreateButton()
    }
}

extension ScheduleViewController: UITableViewDelegate {
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
