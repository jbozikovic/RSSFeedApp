//
//  Reachability+Extensions.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 11.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation

extension Reachability {
    var isReachableOnWiFi: Bool {
        return self.connection == .wifi
    }
    
    var isConnected: Bool {
        return self.connection != .none
    }
}
