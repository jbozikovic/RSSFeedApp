//
//  Utility.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 27.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import UIKit

class Utility: NSObject {
    //  MARK: - Print if DEBUG
    static func printIfDebug(string: String) {
        #if DEBUG
        print(string)
        #endif
    }
        
    //  MARK: - UIBarButtonItem
    static func createBarButtonItem(image: UIImage?, target: Any, action: Selector, identifier: String) -> UIBarButtonItem {
        let btn = UIBarButtonItem(image: image, style: .plain, target: target, action: action)
        btn.accessibilityIdentifier = identifier
        btn.tintColor = .gray
        return btn
    }
}


//  MARK: - Reachability, Internet connection
extension Utility {
    static var hasInternetConnection: Bool {
        guard let reachability = Reachability(), reachability.isConnected else {
            return false
        }
        return true
    }
}
