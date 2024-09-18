//
//  RSSParserService.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 16.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation
import Combine

//  MARK: - RSSTagName
enum RSSTagName: String {
    case channel = "channel"
    case item = "item"
    case title = "title"
    case description = "description"
    case atomLink = "atom:link"
    case pubDate = "pubDate"
    case lastBuildDate = "lastBuildDate"
    case link = "link"
    case image = "image"
    case url = "url"
    case mediaThumbnail = "media:thumbnail"
}


//  MARK: - RSSParserProtocol
protocol RSSParserProtocol {
    var xmlParser: XMLParser { get }
    var didFinishParsing: PassthroughSubject<RSSFeed, Never> { get }
    var failure: PassthroughSubject<Error, Never> { get }
    func parseRSS(with data: Data, url: String)
}

//  MARK: - RSSParserService
class RSSParserService: NSObject, RSSParserProtocol {
    var xmlParser: XMLParser
    private var feed: RSSFeed? = nil
    private var items: [RSSItemAPI] = []
    private var currentItem: RSSItemAPI? = nil
    private var currentElement: String = ""
    private var feedUrl: String = ""
    
    lazy var didFinishParsing = PassthroughSubject<RSSFeed, Never>()
    lazy var failure = PassthroughSubject<Error, Never>()
                
    override init() {
        self.xmlParser = XMLParser()
        super.init()
        xmlParser.delegate = self
    }
            
    func parseRSS(with data: Data, url: String) {
        feedUrl = url
        xmlParser = XMLParser(data: data)
        xmlParser.delegate = self
        xmlParser.parse()
    }
}

//  MARK: - XMLParserDelegate
extension RSSParserService: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        //  XMLParser Delegate function called when it starts parsing an element
        Utility.printIfDebug(string: "RSSParser didStartElement ELEMENT NAME: \(elementName)")
        currentElement = elementName
        if elementName == RSSTagName.channel.rawValue {
            setRSSFeed()
        } else if elementName == RSSTagName.item.rawValue {
            setCurrentRSSItem()
        }
        extractDataFromAttributesIfNeeded(with: elementName, attributeDict: attributeDict)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        //  XMLParser Delegate function called when it ends parsing an element
        Utility.printIfDebug(string: "RSSParser didEndElement ELEMENT NAME: \(elementName)")
        finishRSSItemParsingIfNeeded(with: elementName)
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        Utility.printIfDebug(string: "RSSParser foundCharacters: \(string)")
        guard !string.trimmed.isEmpty else { return }
        processFoundData(value: string)
    }
    
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        //  XMLParser Delegate function called when the parser encounters a CDATABlock
        guard let value = String(data: CDATABlock, encoding: .utf8),
              !value.trimmed.isEmpty else { return }
        Utility.printIfDebug(string: "RSSParser foundCDATA: \(value)")
        processFoundData(value: value)
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        // publish items
        guard var rssFeed = feed,
              !items.isEmpty else { return }
        rssFeed.items = items
        didFinishParsing.send(rssFeed)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: any Error) {
        // XMLParser Delegate function called when a parsing error occurs
        failure.send(parseError)
    }
}
    
//  MARK: - Private
private extension RSSParserService {
    var isRSSFeedElement: Bool {
        feed != nil
    }
    var isRSSItemElement: Bool {
        currentItem != nil
    }
    
    func setRSSFeed() {
        feed = RSSFeed()
        feed?.feedUrl = feedUrl
    }
    
    func setCurrentRSSItem() {
        currentItem = RSSItemAPI()
    }
    
    func extractDataFromAttributesIfNeeded(with elementName: String, attributeDict: [String : String]) {
        guard isRSSItemElement,
              shouldExtractDataFromAttributes(elementName: elementName),
              let url = attributeDict[RSSTagName.url.rawValue] else { return }
        appendToRSSFeedItem(value: url)
    }
    
    func shouldExtractDataFromAttributes(elementName: String) -> Bool {
        [RSSTagName.mediaThumbnail.rawValue].contains(elementName)
    }
    
    func processFoundData(value: String) {
        guard isRSSItemElement else {
            guard isRSSFeedElement else { return }
            appendToRSSFeed(value: value)
            return
        }
        appendToRSSFeedItem(value: value)
    }
    
    func appendToRSSFeed(value: String) {
        feed?.mapElement(elementName: currentElement, value: value)
    }
    
    func appendToRSSFeedItem(value: String) {
        currentItem?.mapElement(elementName: currentElement, value: value)
    }
    
    func finishRSSItemParsingIfNeeded(with elementName: String) {
        guard elementName == RSSTagName.item.rawValue else { return }
        guard let item = currentItem else { return }
        items.append(item)
        currentItem = nil
    }
}
