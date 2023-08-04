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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        navigationItem.title = "Новая привычка"
        
        setupTextField()
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
}
