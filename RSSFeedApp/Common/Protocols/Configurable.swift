//
//  Configurable.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 27.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation

//  MARK: - Configurable
protocol Configurable {
    associatedtype T
    func configure(_ item: T)
}
