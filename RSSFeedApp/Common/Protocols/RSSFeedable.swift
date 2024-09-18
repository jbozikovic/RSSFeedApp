//
//  RSSFeedable.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 16.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation

protocol RSSFeedable {
    var title: String { get set }
    var url: String { get set }
    var imageUrl: String { get set }
    var desc: String { get set }
    var pubDate: String? { get set }    
    mutating func mapElement(elementName: String, value: String)
}

extension RSSFeedable {
    mutating func mapElement(elementName: String, value: String) {
        if elementName == RSSTagName.title.rawValue {
            title = value
        } else if elementName == RSSTagName.description.rawValue {
            desc = value
        } else if elementName == RSSTagName.link.rawValue {
            url = value
        } else if elementName == RSSTagName.pubDate.rawValue {
            pubDate = value
        } else if elementName == RSSTagName.url.rawValue || elementName == RSSTagName.mediaThumbnail.rawValue {
            imageUrl = value
        }
    }
}
