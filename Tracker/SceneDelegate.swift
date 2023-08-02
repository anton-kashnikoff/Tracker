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
        let trackersViewController = TrackersViewController()
        let navigationController = UINavigationController(rootViewController: trackersViewController)
        
        navigationController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "tracker tab bar icon"), selectedImage: nil)
        tabBarController.viewControllers = [navigationController]
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
