//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Антон Кашников on 05.08.2023.
//

import UIKit

final class NewCategoryViewController: UIViewController {
    let textField: TextField = {
        let textField = TextField()
//        textField.identifier = "newCategory"
        textField.placeholder = "Введите название категории"
        textField.layer.cornerRadius = 16
        textField.backgroundColor = .ypBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypGray
//        button.isEnabled = false
        button.layer.cornerRadius = 16
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var categoryViewController: CategoryViewController?
    
    static let didChangeNotification = Notification.Name(rawValue: "CategoriesListDidChange")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        navigationItem.title = "Новая категория"
        
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
        let categoryName = textField.text ?? ""
        let category = TrackerCategory(name: categoryName, trackers: nil)
        categoryViewController?.categories.append(category)
//        print("doneButtonDidTap \(categoryViewController?.categories)")
        NotificationCenter.default.post(name: NewCategoryViewController.didChangeNotification, object: self)
        dismiss(animated: true)
    }
    
//    func activateButton() {
//        print("activate")
//        button.isEnabled = true
//        button.backgroundColor = .ypBlack
//        print(button.backgroundColor)
//    }
//    
//    func deactivateButton() {
//        print("deactivate")
//        button.isEnabled = false
//        button.backgroundColor = .ypGray
//        print(button.backgroundColor)
//    }
//    
//    func toggleButton() {
//        if textField.text == nil || textField.text == "" {
//            button.backgroundColor = .ypGray
//            print(textField.text)
//        } else {
//            button.backgroundColor = .ypBlack
//            print(textField.text)
//        }
//    }
}

//extension UIButton {
//    open override var isEnabled: Bool {
//        didSet {
//            super.isEnabled = isEnabled
//            backgroundColor = isEnabled ? .ypBlack : .ypGray
//            print(backgroundColor)
//        }
//    }
//}
