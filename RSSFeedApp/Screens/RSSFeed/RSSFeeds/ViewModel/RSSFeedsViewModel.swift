//
//  RSSFeedsViewModel.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 14.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation
import Combine

class RSSFeedsViewModel: ObservableObject {
    private var rssFeeds: [RSSChannel] = [] {
        didSet{
            self.prepareDataAndReload()
        }
    }
    @Published var cellViewModels: [RSSFeedListItemViewModel] = []
    @Published var showError = false
    @Published var showDeleteConfirmation = false
    @Published var error: Error?
    private var cancellables = Set<AnyCancellable>()
    private let repository: RSSFeedRepositoryProtocol
    private var channelForDeletion: RSSChannel? = nil
    lazy var didTapListItem = PassthroughSubject<([RSSItem], String), Never>()
    lazy var didTapAddButton = PassthroughSubject<Void, Never>()
    
    init(repository: RSSFeedRepositoryProtocol) {
        self.repository = repository
        handleError()
        handleRepositoryDidFetchData()
        handleRepositoryFailure()
    }
    
    func loadData() {
        rssFeeds = []
        guard let feeds = repository.getRSSFeed() else { return }
        rssFeeds = feeds
    }
    
    func addNewFeed(with url: String) {
        repository.addNewFeed(with: url)
    }
    
    func userTappedOnRSSFeedListItem(feed: RSSChannel) {
        guard let items = feed.items?.allObjects as? [RSSItem] else { return }
        didTapListItem.send((items, feed.title))
    }
    
    func userConfirmedFeedDeletion() {
        guard let channel = channelForDeletion else { return }
        deleteFeed(channel)
        channelForDeletion = nil
        showDeleteConfirmation = false
    }
}

//  MARK: - Publisher
private extension RSSFeedsViewModel {
    func handleError() {
        $error
            .map { $0 != nil }
            .assign(to: \.showError, on: self)
            .store(in: &cancellables)
    }
    
    func handleRepositoryDidFetchData() {
        repository.didFetchData.sink { [weak self] channels in
            guard let weakSelf = self, let channels = channels else { return }
            weakSelf.rssFeeds = []
            weakSelf.rssFeeds = channels
        }.store(in: &cancellables)
    }
    
    func handleRepositoryFailure() {
        repository.failure
            .sink { [weak self] error in
                guard let weakSelf = self else { return }
                weakSelf.error = error
            }.store(in: &cancellables)
    }
}

//  MARK: - Private (prepare data for UI)
private extension RSSFeedsViewModel {
    func prepareDataAndReload() {
        cellViewModels = []
        cellViewModels.append(contentsOf: rssFeeds.map { createCellViewModel(with: $0) })
    }
    
    func createCellViewModel(with channel: RSSChannel) -> RSSFeedListItemViewModel {
        let viewModel = RSSFeedListItemViewModel(rssFeed: channel)
        viewModel.didTapFavorites.sink { [weak self] channel in
            guard let weakSelf = self else { return }
            weakSelf.favoritesAdministrationForFeed(channel)
        }.store(in: &cancellables)
        viewModel.didTapRemoveChannel.sink { [weak self] channel in
            guard let weakSelf = self else { return }
            weakSelf.channelForDeletion = channel
            weakSelf.showDeleteConfirmation = true
        }.store(in: &cancellables)
        return viewModel
    }
}

//  MARK: - Feed administration
private extension RSSFeedsViewModel {
    func favoritesAdministrationForFeed(_ channel: RSSChannel) {
        guard repository.favoritesAdministrationForFeed(channel) else {
            error = AppError.genericError
            return
        }
        loadData()
    }
    
    func deleteFeed(_ channel: RSSChannel) {
        guard repository.deleteFeed(channel) else {
            error = AppError.genericError
            return
        }
        loadData()
    }
}

//  MARK: Computed properties
extension RSSFeedsViewModel {
    var title: String {
        AppStrings.rssFeeds.localized
    }
    var description: String {
        AppStrings.rssFeedsDesc.localized
    }
    var showEmptyView: Bool {
        rssFeeds.isEmpty
    }
}


