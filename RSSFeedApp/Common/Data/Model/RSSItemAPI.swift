//
//  RSSItem.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 16.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation

struct RSSItemAPI: RSSFeedable {
    var title: String = ""
    var url: String = ""
    var imageUrl: String = ""
    var desc: String = ""
    var pubDate: String? = nil
}
