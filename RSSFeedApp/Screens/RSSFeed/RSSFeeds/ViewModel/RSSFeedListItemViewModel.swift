//
//  RSSFeedListItemViewModel.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 18.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation
import Combine

//  MARK: - RSSFeedListItemViewModel (Channel)
class RSSFeedListItemViewModel {
    var rssFeed: RSSChannel
    
    lazy var didTapFavorites = PassthroughSubject<RSSChannel, Never>()
    lazy var didTapRemoveChannel = PassthroughSubject<RSSChannel, Never>()
    
    init(rssFeed: RSSChannel) {
        self.rssFeed = rssFeed
    }
}

extension RSSFeedListItemViewModel {
    var title: String {
        rssFeed.title
    }
    var description: String {
        rssFeed.desc
    }
    var imageUrl: URL? {
        rssFeed.imageUrl.toURL
    }
    var isFavorite: Bool {
        rssFeed.isFavorite
    }
    var url: String {
        rssFeed.url
    }
    var favoritesButtonImage: String {
        rssFeed.isFavorite ? AppImages.favoritesRemove.rawValue : AppImages.favoritesAdd.rawValue
    }
    
    func userTappedFavoritesButton() {
        didTapFavorites.send(rssFeed)
    }
    
    func userTappedRemoveButton() {
        didTapRemoveChannel.send(rssFeed)
    }
}
