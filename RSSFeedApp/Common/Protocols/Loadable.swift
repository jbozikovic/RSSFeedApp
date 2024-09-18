//
//  Loadable.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 27.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation

import Combine

//  MARK: - Loadable
protocol Loadable: AnyObject {
    var isLoading: Bool { get set }
    var loadingStatusUpdated: PassthroughSubject<Bool, Never> { get }
    func updateLoadingStatus()
}

extension Loadable {
    func updateLoadingStatus() {
        isLoading = !isLoading
        loadingStatusUpdated.send(isLoading)
    }
}
