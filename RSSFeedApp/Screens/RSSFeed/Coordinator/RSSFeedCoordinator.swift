//
//  RSSFeedCoordinator.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 14.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

class RSSFeedCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    var viewModel: RSSFeedsViewModel?
    var repository: RSSFeedRepositoryProtocol
    
    private let networkLayerService: NetworkLayerProtocol = NetworkLayerService()
    private var cancellables = Set<AnyCancellable>()
        
    init(presenter: UINavigationController) {
        self.presenter = presenter
        childCoordinators = []
        let apiService = RSSFeedAPIService(networkLayerService: networkLayerService)
        let dbService = RSSFeedDBService(coreDataService: CoreDataService())
        repository = RSSFeedRepository(apiService: apiService, dbService: dbService, parser: RSSParserService())
    }
    
    func start() {        
        setupViewModel()
        navigateToRSSFeedView()
    }
}

//  MARK: - RSS feeds list view model
private extension RSSFeedCoordinator {
    func setupViewModel() {
        viewModel = RSSFeedsViewModel(repository: repository)
        handleDidTapListItemPublisher()
        handleDidTapAddButtonPublisher()
    }
    
    func handleDidTapListItemPublisher() {
        viewModel?.didTapListItem.sink { [weak self] (items, title) in
            guard let weakSelf = self else { return }
            weakSelf.navigateToRSItemsView(items: items, title: title)
        }.store(in: &cancellables)
    }
    
    func handleDidTapAddButtonPublisher() {
        viewModel?.didTapAddButton.sink(receiveValue: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.presentAddFeedView()
        }).store(in: &cancellables)    }
}

//  MARK: - RSS feeds (channel) list
private extension RSSFeedCoordinator {
    private func navigateToRSSFeedView() {
        guard let vm = viewModel else { return }
        let hostingController: UIHostingController = UIHostingController(rootView: RSSFeedsView(viewModel: vm))
        presenter.pushViewController(hostingController, animated: true)
    }
}

//  MARK: - Add new feed
private extension RSSFeedCoordinator {
    var addRSSFeedViewViewModel: AddRSSFeedViewViewModel {
        let viewModel = AddRSSFeedViewViewModel()
        viewModel.didTapAddButton.sink { [weak self] url in
            guard let weakSelf = self else { return }
            weakSelf.viewModel?.addNewFeed(with: url)
        }.store(in: &cancellables)
        return viewModel
    }
    
    func presentAddFeedView() {
        let viewModel = addRSSFeedViewViewModel
        let hostingController: UIHostingController = UIHostingController(rootView: AddRSSFeedView(viewModel: viewModel))
        presenter.present(hostingController, animated: true)
    }
}

//  MARK: - RSS items list view, RSS item details view
private extension RSSFeedCoordinator {
    func rssItemsViewModel(items: [RSSItem]) -> RSSItemsViewModel {
        let viewModel = RSSItemsViewModel(rssItems: items)
        viewModel.onSelectedRSSItemPublisher.sink { [weak self] rssItem in
            guard let weakSelf = self else { return }
            weakSelf.navigateToRSSItemDetailsView(item: rssItem)
        }.store(in: &cancellables)        
        return viewModel
    }
    
    func navigateToRSItemsView(items: [RSSItem], title: String) {
        let viewModel = rssItemsViewModel(items: items)
        let hostingController: UIHostingController = UIHostingController(rootView: RSSItemsView(viewModel: viewModel))
        hostingController.title = title
        presenter.pushViewController(hostingController, animated: true)
    }
        
    func navigateToRSSItemDetailsView(item: RSSItem) {
        let viewModel = RSSItemDetailsViewModel(rssItem: item)
        let hostingController: UIHostingController = UIHostingController(rootView: RSSItemDetailsView(viewModel: viewModel))
        hostingController.title = item.title
        presenter.pushViewController(hostingController, animated: true)
    }
}
