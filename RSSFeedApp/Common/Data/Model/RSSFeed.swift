//
//  RSSFeed.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 16.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation

struct RSSFeed: RSSFeedable {
    var title: String = ""
    var url: String = ""
    var imageUrl: String = ""
    var desc: String = ""
    var pubDate: String? = nil
//    var lastBuildDate: String? = nil
    var items: [RSSItemAPI] = []
    var isFavorite: Bool = false
    var feedUrl: String = ""
}
