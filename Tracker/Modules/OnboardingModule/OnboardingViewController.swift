//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Антон Кашников on 02/09/2023.
//

import UIKit

final class OnboardingViewController: UIViewController {
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .ypAlwaysBlack
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypAlwaysBlack
        button.layer.cornerRadius = 16
        button.setTitle(NSLocalizedString("onboarding.button.title", comment: "Title for button on onboarding screen"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(labelText: String, backgroundImage: UIImage) {
        label.text = labelText
        imageView.image = backgroundImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageView()
        setupLabel()
        setupButton()
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupLabel() {
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -270)
        ])
    }
    
    private func setupButton() {
        button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 60),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc
    private func buttonDidTap() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        
        UserDefaults.standard.hasOnboarded = true
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.layer.borderWidth = 0.5
        tabBarController.tabBar.layer.borderColor = UIColor.tabBarBorderColor.cgColor
        
        let trackersViewController = TrackersViewController()
        
        let statisticsViewController = StatisticsViewController(trackerViewModel: trackersViewController.trackerViewModel, trackerRecordViewModel: trackersViewController.trackerRecordViewModel)
        
        let trackersNavigationController = UINavigationController(rootViewController: trackersViewController)
        let statisticsNavigationController = UINavigationController(rootViewController: statisticsViewController)
        
        trackersNavigationController.tabBarItem = UITabBarItem(title: NSLocalizedString("trackersTitle", comment: "Title for Trackers tab bar item"), image: .trackerIcon, selectedImage: nil)
        statisticsNavigationController.tabBarItem = UITabBarItem(title: NSLocalizedString("statisticsTitle", comment: "Title for Statistics tab bar item"), image: .statisticsIcon, selectedImage: nil)
        tabBarController.viewControllers = [trackersNavigationController, statisticsNavigationController]
        
        sceneDelegate.window?.rootViewController = tabBarController
    }
}
