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
        
        var viewController: UIViewController!
        
        if UserDefaults.standard.hasOnboarded {
            let tabBarController = UITabBarController()
            tabBarController.tabBar.layer.borderWidth = 0.5
            tabBarController.tabBar.layer.borderColor = UIColor.tabBarBorderColor.cgColor
            
            let trackersViewController = TrackersViewController()
            
            let temporaryVC = UIViewController()
            temporaryVC.view.backgroundColor = .systemBackground
            
            let navigationController = UINavigationController(rootViewController: trackersViewController)
            navigationController.tabBarItem = UITabBarItem(title: NSLocalizedString("trackersTitle", comment: "Title for Trackers tab bar item"), image: .trackerIcon, selectedImage: nil)
            temporaryVC.tabBarItem = UITabBarItem(title: NSLocalizedString("tabbar.statisticsItem.title", comment: "Title for Statistics tab bar item"), image: .statisticsIcon, selectedImage: nil)
            tabBarController.viewControllers = [navigationController, temporaryVC]
            
            viewController = tabBarController
        } else {
            viewController = OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
