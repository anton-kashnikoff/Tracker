//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Антон Кашников on 05.08.2023.
//

import UIKit

final class NewCategoryViewController: UIViewController {
    private let textField: TextField = {
        let textField = TextField()
        textField.identifier = "newCategory"
        textField.placeholder = NSLocalizedString("newCategory.textField.placeholder", comment: "Placeholder for text field to add new category")
        textField.layer.cornerRadius = 16
        textField.backgroundColor = .ypBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypGray
        button.layer.cornerRadius = 16
        button.setTitle(NSLocalizedString("done", comment: "Done title"), for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var categoryViewController: CategoryViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissKeyboard()
        
        view.backgroundColor = .ypWhite
        
        navigationItem.hidesBackButton = true
        navigationItem.title = NSLocalizedString("newCategory.navigationItem.title", comment: "Title for new category screen")
        
        setupTextField()
        setupButton()
    }
    
    private func setupTextField() {
        textField.newCategoryViewController = self
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
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
    
    @objc
    private func doneButtonDidTap() {
        categoryViewController?.viewModel.addNewTrackerCategory(TrackerCategory(name: textField.text ?? "", trackers: []))
        navigationController?.popViewController(animated: true)
    }
}
