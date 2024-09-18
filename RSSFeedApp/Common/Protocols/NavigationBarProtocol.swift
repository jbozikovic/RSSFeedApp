//
//  NavigationBarProtocol.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 27.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import UIKit

//  MARK: - NavigationBarProtocol
protocol NavigationBarProtocol {
    func setupNavigationBar()
    func setupNavigationBarItems()
}

extension NavigationBarProtocol where Self: UIViewController {
    func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = UIBarStyle.default
        navigationController?.navigationBar.barTintColor = AppUI.navigationBarBGColor
        navigationController?.navigationBar.tintColor = AppUI.navigationBarTintColor
        setupLargeTitleForNavBar()
    }
    
    private func setupLargeTitleForNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let navBarAppearance = navigationBarAppearance()
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    private func navigationBarAppearance() -> UINavigationBarAppearance {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: AppUI.navigationBarTintColor, .font: AppUI.navigationBarLargeTitleFont]
        navBarAppearance.backgroundColor = AppUI.backgroundColor
        return navBarAppearance
    }
    
    func setupNavigationBarItems() {
        navigationItem.hidesBackButton = false
        navigationItem.leftBarButtonItems = []
    }
}
