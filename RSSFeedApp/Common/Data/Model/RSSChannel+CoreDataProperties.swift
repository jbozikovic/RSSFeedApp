//
//  RSSChannel+CoreDataProperties.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 17.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//
//

import Foundation
import CoreData


extension RSSChannel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RSSChannel> {
        return NSFetchRequest<RSSChannel>(entityName: "RSSChannel")
    }

    @NSManaged public var desc: String
    @NSManaged public var imageUrl: String
    @NSManaged public var isFavorite: Bool
    @NSManaged public var pubDate: String?
    @NSManaged public var title: String
    @NSManaged public var url: String
    @NSManaged public var feedUrl: String
    @NSManaged public var items: NSSet?
}

// MARK: Generated accessors for items
extension RSSChannel {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: RSSItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: RSSItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension RSSChannel : Identifiable {

}
