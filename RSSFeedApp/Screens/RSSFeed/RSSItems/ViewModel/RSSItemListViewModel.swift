//
//  RSSItemListViewModel.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 18.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation

class RSSItemListViewModel {
    var rssItem: RSSItem
    
    init(rssItem: RSSItem) {
        self.rssItem = rssItem
    }
}

extension RSSItemListViewModel {
    var title: String {
        rssItem.title
    }
    var description: String {
        rssItem.desc
    }
    var imageUrl: URL? {
        rssItem.imageUrl.toURL
    }
    var url: String {
        rssItem.url
    }
}
