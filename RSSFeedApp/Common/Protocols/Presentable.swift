//
//  Presentable.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 27.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import UIKit

//  MARK: - Presentable
protocol Presentable {
    func presentAlertController(title: String? , message: String, showCancelButton: Bool, confirmHandler: (() -> Void)?)
}

extension Presentable where Self: UIViewController {
    func presentAlertController(title: String? = nil, message: String, showCancelButton: Bool, confirmHandler: (() -> Void)?) {
        let t = title?.localized() ?? ""
        let alert: UIAlertController = UIAlertController(title: t, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AppStrings.ok.localized, style: .default, handler: { (action) in
            if let handler = confirmHandler {
                handler()
            }
        }))
        if showCancelButton {
            alert.addAction(UIAlertAction(title: AppStrings.cancel.localized, style: .cancel, handler: nil))
        }
        present(alert, animated: true)
    }
}
