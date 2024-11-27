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

        // MARK: - Home screen setup

        let vc1 = HomeViewController()
        vc1.navigationItem.largeTitleDisplayMode = .always
        let nav1 = UINavigationController(rootViewController: vc1)
        nav1.navigationItem.titleView?.tintColor = .label
        nav1.tabBarItem = UITabBarItem(title: LocalizationKeys.HOME,
                                       image: UIImage(systemName: "house"),
                                       tag: 1)
        nav1.navigationBar.prefersLargeTitles = true

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
    }
}
