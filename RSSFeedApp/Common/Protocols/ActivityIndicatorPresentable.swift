//
//  ActivityIndicatorPresentable.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 27.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import UIKit

//  MARK: - ActivityIndicatorPresentable
protocol ActivityIndicatorPresentable {
    func showActivityIndicator()
    func hideActivityIndicator()
}

extension ActivityIndicatorPresentable where Self: UIViewController {
    func showActivityIndicator() {
        guard let activityIndicator = getActivityIndicator() else {
            createActivityIndicatorView()
            return
        }
        activityIndicator.startAnimating()
    }
        
    func hideActivityIndicator() {
        getActivityIndicator()?.stopAnimating()
    }

    private func getActivityIndicator() -> UIActivityIndicatorView? {
        return view.subviews.compactMap { $0 as? UIActivityIndicatorView }.first
    }
    
    private func createActivityIndicatorView() {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = .black
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        activityIndicatorView.startAnimating()
    }
}
