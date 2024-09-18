//
//  AddRSSFeedViewViewModel.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 17.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import UIKit
import Combine

class AddRSSFeedViewViewModel: ObservableObject {
    @Published var feedUrl = ""
    @Published var isSubmitEnabled = false
    private var cancellables = Set<AnyCancellable>()
    lazy var didTapAddButton = PassthroughSubject<String, Never>()
    
    private var isValidURL: AnyPublisher<Bool, Never> {
        $feedUrl
            .map { $0.isValidURL }
            .eraseToAnyPublisher()
    }
    
    init() {
        handleIsValidURL()
    }
    
    private func handleIsValidURL() {
        isValidURL
            .receive(on: RunLoop.main)
            .assign(to: \.isSubmitEnabled, on: self)
            .store(in: &cancellables)
    }
    
    func userTappedAddFeedButton() {
        didTapAddButton.send(feedUrl)
    }
}

