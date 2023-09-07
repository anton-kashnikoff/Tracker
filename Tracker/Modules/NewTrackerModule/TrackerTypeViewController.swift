//
//  TrackerTypeViewController.swift
//  Tracker
//
//  Created by Антон Кашников on 02.08.2023.
//

import UIKit

final class TrackerTypeViewController: UIViewController {
    let habitButton: UIButton = {
        let habitButton = UIButton()
        habitButton.backgroundColor = .ypBlack
        habitButton.layer.cornerRadius = 16
        habitButton.layer.masksToBounds = true
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.setTitleColor(.ypWhite, for: .normal)
        habitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        return habitButton
    }()
    
    let irregularEventButton: UIButton = {
        let irregularEventButton = UIButton()
        irregularEventButton.backgroundColor = .ypBlack
        irregularEventButton.layer.cornerRadius = 16
        irregularEventButton.layer.masksToBounds = true
        irregularEventButton.setTitle("Нерегулярное событие", for: .normal)
        irregularEventButton.setTitleColor(.ypWhite, for: .normal)
        irregularEventButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        irregularEventButton.translatesAutoresizingMaskIntoConstraints = false
        return irregularEventButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.title = "Создание трекера"
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        
        setupHabitButton()
        setupIrregularEventButton()
    }
    
    weak var trackersViewController: TrackersViewController?
    
    private func setupHabitButton() {
        habitButton.addTarget(self, action: #selector(didTapHabitButton), for: .touchUpInside)
        view.addSubview(habitButton)
        
        NSLayoutConstraint.activate([
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 281),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupIrregularEventButton() {
        irregularEventButton.addTarget(self, action: #selector(didTapIrregularEventButton), for: .touchUpInside)
        view.addSubview(irregularEventButton)
        
        NSLayoutConstraint.activate([
            irregularEventButton.heightAnchor.constraint(equalToConstant: 60),
            irregularEventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            irregularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            irregularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc
    private func didTapHabitButton() {
        let newHabitViewController = NewTrackerViewController(trackerType: .habit)
        newHabitViewController.trackersViewController = trackersViewController
        newHabitViewController.trackerViewModel = trackersViewController?.trackerViewModel
        navigationController?.pushViewController(newHabitViewController, animated: true)
    }
    
    @objc
    private func didTapIrregularEventButton() {
        let newIrregularEventViewController = NewTrackerViewController(trackerType: .irregularEvent)
        newIrregularEventViewController.trackersViewController = trackersViewController
        newIrregularEventViewController.trackerViewModel = trackersViewController?.trackerViewModel
        navigationController?.pushViewController(newIrregularEventViewController, animated: true)
    }
}
