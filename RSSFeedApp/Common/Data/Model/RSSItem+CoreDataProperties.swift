//
//  RSSItem+CoreDataProperties.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 17.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//
//

import Foundation
import CoreData


extension RSSItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RSSItem> {
        return NSFetchRequest<RSSItem>(entityName: "RSSItem")
    }

    @NSManaged public var title: String
    @NSManaged public var url: String
    @NSManaged public var imageUrl: String
    @NSManaged public var desc: String
    @NSManaged public var pubDate: String?
    @NSManaged public var channel: RSSChannel?

}

extension RSSItem : Identifiable {

}
