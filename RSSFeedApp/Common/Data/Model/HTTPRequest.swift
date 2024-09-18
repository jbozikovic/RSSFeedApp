//
//  HTTPRequest.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 27.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation

//  MARK: - HTTPMethod
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case head = "HEAD"
}

//  MARK: - HTTPHeader
struct HTTPHeader {
    var value: String
    var headerField: String
}

//  MARK: - HTTPRequest
struct HTTPRequest: Requestable {
    var method: HTTPMethod
    @URLFormatter var url: String
    var params: [String : Any]?
    var headers: [HTTPHeader]?
}
