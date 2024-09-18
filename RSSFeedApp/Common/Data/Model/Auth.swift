//
//  Auth.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 29.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation

struct Auth: Codable {
    var authToken: String
    
    // MARK: - CodingKeys
    private enum CodingKeys: String, CodingKey {
        case authToken = "auth_token"
    }
}
