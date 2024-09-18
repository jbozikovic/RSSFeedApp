//
//  RSSFeedRepository.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 16.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation
import Combine

//  MARK: - RSSFeedRepositoryProtocol
protocol RSSFeedRepositoryProtocol {
    func getRSSFeed() -> [RSSChannel]?
    func addNewFeed(with url: String)
    func favoritesAdministrationForFeed(_ channel: RSSChannel) -> Bool
    func deleteFeed(_ channel: RSSChannel) -> Bool
    var didFetchData: PassthroughSubject<[RSSChannel]?, Never> { get }
    var failure: PassthroughSubject<Error, Never> { get }
}

//  MARK: - RepositoryListRepository
class RSSFeedRepository: NSObject, RSSFeedRepositoryProtocol {
    let apiService: RSSFeedAPIProtocol
    let dbService: RSSFeedDBDBProtocol
    let parser: RSSParserProtocol
    
    private var cancellables = Set<AnyCancellable>()
    lazy var didFetchData = PassthroughSubject<[RSSChannel]?, Never>()
    lazy var failure = PassthroughSubject<Error, Never>()

    init(apiService: RSSFeedAPIProtocol, dbService: RSSFeedDBDBProtocol, parser: RSSParserProtocol) {
        self.apiService = apiService
        self.dbService = dbService
        self.parser = parser
        super.init()
        handleParserDidFinishParsingPublisher()
    }
    
    /** Returns RSS feed. In production app this function would determine should it return data from API or DB by
     comparing lastBuildDate of each saved feed with the feed lastBuildDate fetched from web.
    @author Jurica Bozikovic
    */
    func getRSSFeed() -> [RSSChannel]? {
        guard !shouldFetchFromAPI else {
            return getRSSFeedFromAPI()
        }
        return getRSSFeedFromDB()
    }
        
    func addNewFeed(with url: String) {
        guard canAddChannel(with: url) else {
            return failure.send(AppError.feedAlreadyExists)
        }
        apiService.getRSSFeedData(with: url)
            .sink { [weak self] completion in
                guard let weakSelf = self else { return }
                switch completion {
                case .failure(let error):
                    weakSelf.failure.send(error)
                    Utility.printIfDebug(string: "Failure while fetchig data: \(completion).")
                case .finished:
                    Utility.printIfDebug(string: "Received completion: \(completion).")
                }
            } receiveValue: { [weak self] data in
                guard let weakSelf = self else { return }
                weakSelf.parseRSS(with: data, feedUrl: url)
            }.store(in: &cancellables)
    }
    
    func favoritesAdministrationForFeed(_ channel: RSSChannel) -> Bool {
        dbService.updateChannel(channel: channel)
    }
    
    func deleteFeed(_ channel: RSSChannel) -> Bool {
        dbService.deleteChannel(channel)
    }
}

//  MARK: - Private
private extension RSSFeedRepository {
    func canAddChannel(with url: String) -> Bool {
        guard let savedFeeds = getRSSFeed() else { return true }
        return (savedFeeds.first { $0.feedUrl == url } == nil)
    }
    
    func parseRSS(with data: Data, feedUrl: String) {
        parser.parseRSS(with: data, url: feedUrl)
    }
    
    func handleParserDidFinishParsingPublisher() {
        parser.didFinishParsing.sink { [weak self] completion in
            guard let weakSelf = self else { return }
            switch completion {
            case .failure(let error):
                Utility.printIfDebug(string: "Error while parsing RSS feed: \(error.localizedDescription)")
                weakSelf.failure.send(error)
            case .finished:
                Utility.printIfDebug(string: "Finished parsing RSS feed")
            }
        } receiveValue: { [weak self] rssFeed in
            guard let weakSelf = self else { return }
            weakSelf.addNewChannelToDBAndReload(rssFeed: rssFeed)
        }.store(in: &cancellables)
    }
    
    func handleParserError() {
        parser.failure
            .sink { [weak self] error in
                guard let weakSelf = self else { return }
                weakSelf.failure.send(error)
            }.store(in: &cancellables)
    }
    
    func addNewChannelToDBAndReload(rssFeed: RSSFeed) {
        _ = dbService.createChannel(with: rssFeed)
        let feeds = getRSSFeed()
        didFetchData.send(feeds)
    }
}

//  MARK: - Check should we fetch data from API or not
private extension RSSFeedRepository {
    var shouldFetchFromAPI: Bool {
        false
    }
}

//  MARK: - Fetch data from API
private extension RSSFeedRepository {
    func getRSSFeedFromAPI() -> [RSSChannel]? {
        nil
    }
}

//  MARK: - DB
private extension RSSFeedRepository {
    func getRSSFeedFromDB() -> [RSSChannel]? {
        dbService.getChannels()
    }
}



