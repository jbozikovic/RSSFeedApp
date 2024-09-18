//
//  RSSItemsViewModel.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 16.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation
import Combine

class RSSItemsViewModel: ObservableObject {
    private var rssItems: [RSSItem] = [] {
        didSet{
            self.prepareDataAndReload()
        }
    }
    @Published var cellViewModels: [RSSItemListViewModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    /// Subject which is triggered when user taps on the RSS item
    private let selectedRSSItemSubject = PassthroughSubject<RSSItem, Never>()
    var onSelectedRSSItemPublisher: AnyPublisher<RSSItem, Never> {
        selectedRSSItemSubject.eraseToAnyPublisher()
    }
    
    init(rssItems: [RSSItem]) {
        self.rssItems = rssItems
        prepareDataAndReload()
    }
        
    private func prepareDataAndReload() {
        cellViewModels = []
        cellViewModels = rssItems.map { RSSItemListViewModel(rssItem: $0) }
    }    
    
    func userTappedItem(rssItem: RSSItem) {
        selectedRSSItemSubject.send(rssItem)
    }
}
