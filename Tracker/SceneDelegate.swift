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
            
            let statisticsViewController = StatisticsViewController(trackerViewModel: trackersViewController.trackerViewModel, trackerRecordViewModel: trackersViewController.trackerRecordViewModel)
            
            let trackersNavigationController = UINavigationController(rootViewController: trackersViewController)
            let statisticsNavigationController = UINavigationController(rootViewController: statisticsViewController)
            
            trackersNavigationController.tabBarItem = UITabBarItem(title: NSLocalizedString("trackersTitle", comment: "Title for Trackers tab bar item"), image: .trackerIcon, selectedImage: nil)
            statisticsNavigationController.tabBarItem = UITabBarItem(title: NSLocalizedString("statisticsTitle", comment: "Title for Statistics tab bar item"), image: .statisticsIcon, selectedImage: nil)
            tabBarController.viewControllers = [trackersNavigationController, statisticsNavigationController]
            
            viewController = tabBarController
        } else {
            viewController = OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
