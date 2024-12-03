//
//  TabBarViewController.swift
//  Spotify-Clone
//
//  Created by Vikas Joshi on 20/11/24.
//

import UIKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()

        // MARK: - Home screen setup

        let vc1 = HomeViewController()
        vc1.navigationItem.largeTitleDisplayMode = .never
        let nav1 = UINavigationController(rootViewController: vc1)
        nav1.navigationItem.titleView?.tintColor = .label
        nav1.tabBarItem = UITabBarItem(title: LocalizationKeys.HOME,
                                       image: UIImage(systemName: "house"),
                                       tag: 1)

        // MARK: - Search screen setup

        let vc2 = SearchViewController()
        vc2.navigationItem.largeTitleDisplayMode = .always
        let nav2 = UINavigationController(rootViewController: vc2)
        nav2.navigationItem.titleView?.tintColor = .label
        nav2.tabBarItem = UITabBarItem(title: LocalizationKeys.SEARCH,
                                       image: UIImage(systemName: "magnifyingglass"),
                                       tag: 2)
        nav2.navigationBar.prefersLargeTitles = true

        // MARK: - Library screen setup

        let vc3 = LibraryViewController()
        vc3.navigationItem.largeTitleDisplayMode = .always
        let nav3 = UINavigationController(rootViewController: vc3)
        nav3.navigationItem.titleView?.tintColor = .label
        nav3.tabBarItem = UITabBarItem(title: LocalizationKeys.LIBRARY,
                                       image: UIImage(systemName: "music.note.list"),
                                       tag: 3)
        nav3.navigationBar.prefersLargeTitles = true

        // MARK: - Set view controllers to tab bar

        setViewControllers([nav1, nav2, nav3], animated: false)
        setupNavBar(nav1: nav1,
                    nav2: nav2,
                    nav3: nav3)
    }

    private func setupTabBar() {
        // Set the tab bar's background color
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.black // Background color
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemBlue // Selected icon color
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor.systemBlue // Selected text color
            ]
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.systemGray // Unselected icon color
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.systemGray // Unselected text color
            ]
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        } else {
            tabBar.barTintColor = UIColor.systemGray5 // Background color for earlier versions
            tabBar.tintColor = UIColor.systemBlue // Selected tab color
            tabBar.unselectedItemTintColor = UIColor.systemGray // Unselected tab color
        }
    }

    private func setupNavBar(nav1: UINavigationController,
                             nav2: UINavigationController,
                             nav3: UINavigationController)
    {
        let appearance = UINavigationBarAppearance()

        // Configure appearance
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 18)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 32)
        ]

        // Apply to all UINavigationControllers
        [nav1, nav2, nav3].forEach { navController in
            navController.navigationBar.standardAppearance = appearance
            navController.navigationBar.scrollEdgeAppearance = appearance
            navController.navigationBar.compactAppearance = appearance
            navController.navigationBar.tintColor = UIColor.white
        }
    }
}
