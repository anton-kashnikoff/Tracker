//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Антон Кашников on 28.07.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.layer.borderWidth = 0.5
        tabBarController.tabBar.layer.borderColor = UIColor.tabBarBorderColor.cgColor
        let trackersViewController = TrackersViewController()
        let temporaryVC = UIViewController()
        temporaryVC.view.backgroundColor = .systemBackground
        let navigationController = UINavigationController(rootViewController: trackersViewController)
        
        navigationController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "tracker tab bar icon"), selectedImage: nil)
        temporaryVC.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "statistics tab bar icon"), selectedImage: nil)
        tabBarController.viewControllers = [navigationController, temporaryVC]
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
