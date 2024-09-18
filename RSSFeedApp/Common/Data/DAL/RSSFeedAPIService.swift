//
//  RSSFeedAPIService.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 16.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation
import Combine

//  MARK: - RSSFeedAPIProtocol
protocol RSSFeedAPIProtocol {
    func getRSSFeedData(with url: String) -> AnyPublisher<Data, Error>
}

//  MARK: - RSSFeedAPIService
class RSSFeedAPIService: NSObject, RSSFeedAPIProtocol {
    private let networkLayerService: NetworkLayerProtocol
    
    init(networkLayerService: NetworkLayerProtocol) {
        self.networkLayerService = networkLayerService
    }
            
    func getRSSFeedData(with url: String) -> AnyPublisher<Data, Error> {
        let request: HTTPRequest = HTTPRequest(method: .get, url: url, params: nil, headers: nil)
        return networkLayerService.executeNetworkRequest(request: request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}

