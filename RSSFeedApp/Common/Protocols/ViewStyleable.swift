//
//  ViewStyleable.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 27.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import UIKit

//  MARK: - ViewStyleable
protocol ViewStyleable {
    func setupGUI()
    func setupBackground()
}

extension ViewStyleable where Self: UIViewController {
    func setupBackground() {
        view.backgroundColor = AppUI.defaultBgColor
    }
}

