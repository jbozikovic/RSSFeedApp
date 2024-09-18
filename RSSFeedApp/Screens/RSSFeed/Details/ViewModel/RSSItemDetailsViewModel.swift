//
//  RSSItemDetailsViewModel.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 16.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation
import Combine

class RSSItemDetailsViewModel: ObservableObject {
    @Published private var rssItem: RSSItem
        
    init(rssItem: RSSItem) {
        self.rssItem = rssItem
    }
}

extension RSSItemDetailsViewModel {    
    var url: String {
        rssItem.url
    }
}
