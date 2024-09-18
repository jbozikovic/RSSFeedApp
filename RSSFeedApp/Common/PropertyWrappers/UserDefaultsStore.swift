//
//  UserDefaultsStore.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 16.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefaultsStore<T> {
    private let key: String
    private let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            // Set value to UserDefaults
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
