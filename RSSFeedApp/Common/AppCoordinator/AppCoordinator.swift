//
//  AppCoordinator.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 11.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import UIKit
import Combine

//  MARK: - Coordinator protocol
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var presenter: UINavigationController { get set }
    func start()
}

extension Coordinator {
    func addChildCoordinator(coordinator: Coordinator) {
        self.childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(coordinator: Coordinator) {
        guard !self.childCoordinators.isEmpty else { return }
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
    }
    
    func removeAllChildCoordinators() {
        self.childCoordinators.removeAll()
    }
}


//  MARK: - AppCoordinator
class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    var presenter: UINavigationController
    let window: UIWindow?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init(window: UIWindow?) {
        self.window = window
        presenter = UINavigationController()
        childCoordinators = []
    }
    
    func start() {
        guard let window = self.window else { return }
        window.rootViewController = presenter
        window.makeKeyAndVisible()
        performStartupChecks()
    }
}

//  MARK: - Startup checks
private extension AppCoordinator {
    var isUserLoggedIn: Bool {
//        let authService = AuthService(networkLayerService: NetworkLayerService(), keychainService: KeychainService())
//        return authService.getAuthToken() != nil   
        true
    }
    
    func performStartupChecks() {
        guard isUserLoggedIn else { return startLoginCoordinator() }
        startRSSFeedCoordinator()
    }
}

//  MARK: - LoginCoordinator
private extension AppCoordinator {
    func startLoginCoordinator() {}
}

//  MARK: - RSSFeedCoordinator
private extension AppCoordinator {
    func startRSSFeedCoordinator() {
        let coordinator = RSSFeedCoordinator(presenter: presenter)
        addChildCoordinator(coordinator: coordinator)
        coordinator.start()
    }
}
