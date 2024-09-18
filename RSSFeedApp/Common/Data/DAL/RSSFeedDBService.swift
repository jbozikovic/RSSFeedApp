//
//  RSSFeedDBService.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 17.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import CoreData

//  MARK: - RSSFeedDBDBProtocol
protocol RSSFeedDBDBProtocol {
    func getChannels() -> [RSSChannel]?
    func createChannel(with apiModel: RSSFeed) -> RSSChannel?
    func updateChannel(channel: RSSChannel) -> Bool
    func deleteChannel(_ channel: RSSChannel) -> Bool
}

//  MARK: - RSSCFeedDBService
class RSSFeedDBService: RSSFeedDBDBProtocol {
    private let coreDataService: CoreDataProtocol
    
    init(coreDataService: CoreDataProtocol) {
        self.coreDataService = coreDataService
    }
    
    func getChannels() -> [RSSChannel]? {
        guard let items = coreDataService.fetchItems(with: CoreDataServiceConstants.entityChannel, sortDescriptor: sortDescriptor),
              let channels = items as? [RSSChannel] else { return nil }
        return channels
    }
            
    func createChannel(with apiModel: RSSFeed) -> RSSChannel? {
        guard let entity = coreDataService.createEntity(with: CoreDataServiceConstants.entityChannel),
              let channel = entity as? RSSChannel else {
            return nil
        }
        channel.title = apiModel.title
        channel.url = apiModel.url
        channel.imageUrl = apiModel.imageUrl
        channel.desc = apiModel.desc
        channel.pubDate = apiModel.pubDate
        channel.isFavorite = false
        channel.feedUrl = apiModel.feedUrl
        processRSSItems(apiModel.items, for: channel)
        guard coreDataService.saveContext() else { return nil }
        return channel
    }
    
    func updateChannel(channel: RSSChannel) -> Bool {
        channel.isFavorite.toggle()
        return coreDataService.saveContext()
    }
    
    func deleteChannel(_ channel: RSSChannel) -> Bool {
        coreDataService.deleteItem(channel)
    }
}

//  MARK: - RSSItem
private extension RSSFeedDBService {
    func processRSSItems(_ items: [RSSItemAPI], for channel: RSSChannel) {
        items.forEach { apiItem in
            guard let item = createRSSItem(for: channel, with: apiItem) else { return }
            channel.addToItems(item)
        }
    }
    
    func createRSSItem(for channel: RSSChannel, with apiItem: RSSItemAPI) -> RSSItem? {
        guard let entity = coreDataService.createEntity(with: CoreDataServiceConstants.entityItem),
              let item = entity as? RSSItem else {
            return nil
        }
        item.title = apiItem.title
        item.url = apiItem.url
        item.imageUrl = apiItem.imageUrl
        item.desc = apiItem.desc
        item.pubDate = apiItem.pubDate
        item.channel = channel
        return item
    }
}

//  MARK: - Sort descriptor
private extension RSSFeedDBService {
    var sortDescriptor: [NSSortDescriptor] {
        [NSSortDescriptor(key: "isFavorite", ascending: false)]
    }
}
