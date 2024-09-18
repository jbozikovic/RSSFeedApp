//
//  Requestable.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 27.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation

//  MARK: - Requestable protocol
protocol Requestable {
    var method: HTTPMethod { get }
    var url: String { get }
    var params: JSON? { get }
    var headers: [HTTPHeader]? { get }
}
