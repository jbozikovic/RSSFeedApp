//
//  URLFormatter.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 11.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation

@propertyWrapper
struct URLFormatter {
    var wrappedValue: String {
        didSet {
            wrappedValue = wrappedValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? wrappedValue
        }
    }
    
    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? wrappedValue
    }
}
