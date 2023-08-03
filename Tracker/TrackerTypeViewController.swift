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
        habitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        habitButton.titleLabel?.textColor = .ypWhite
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        return habitButton
    }()
    
    let irregularEventButton: UIButton = {
        let irregularEventButton = UIButton()
        irregularEventButton.backgroundColor = .ypBlack
        irregularEventButton.layer.cornerRadius = 16
        irregularEventButton.layer.masksToBounds = true
        irregularEventButton.setTitle("Нерегулярное событие", for: .normal)
        irregularEventButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        irregularEventButton.titleLabel?.textColor = .ypWhite
        irregularEventButton.translatesAutoresizingMaskIntoConstraints = false
        return irregularEventButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.title = "Создание трекера"
        
        setupHabitButton()
        setupIrregularEventButton()
    }
    
    private func setupHabitButton() {
        view.addSubview(habitButton)
        
        NSLayoutConstraint.activate([
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 281),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupIrregularEventButton() {
        view.addSubview(irregularEventButton)
        
        NSLayoutConstraint.activate([
            irregularEventButton.heightAnchor.constraint(equalToConstant: 60),
            irregularEventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            irregularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            irregularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
