//
//  Constants.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 11.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation

import Foundation
import UIKit


//  MARK: - Constants
struct Constants {
    private init() {}
            
    static let networkTimeout: TimeInterval = 10     //  network timeout in seconds ...
    static let defaultNumberOfSections: Int = 1
    static let numberOfItemsPerPage: Int = 50
    static let dateFormat: String = "MMM dd, yyyy"
    static let timeFormat: String = "HH:mm"
}


//  MARK: - App config
struct AppConfig {
    private init() {}
}


//  MARK: - AppUI
struct AppUI {
    static let defaultPadding: CGFloat = 14.0
    static let alphaHidden: CGFloat = 0.0
    static let alphaVisible: CGFloat = 1.0
    static let alphaTransparent: CGFloat = 0.5
    static let listBodyFont: Font = Font.system(size: 13.0)
    static let defaultBgColor: UIColor = .white
    static let cornerRadius: CGFloat = 8.0
    static let backgroundColor: UIColor = .white
    static let navigationBarBGColor: UIColor = .white
    static let navigationBarTintColor: UIColor = .black
    static let navigationBarLargeTitleFont: UIFont = UIFont.boldSystemFont(ofSize: 24.0)
}

import SwiftUI
//  MARK: - AppImages
enum AppImages: String {
    case favoritesAdd = "star"
    case favoritesRemove = "star.fill"
    case remove = "trash.fill"
        
    var image: UIImage? {
        guard let systemImage = UIImage(systemName: self.rawValue) else {
            return UIImage(named: self.rawValue)
        }
        return systemImage
    }
}


//  MARK: - AppStrings
enum AppStrings: String {
    case add = "add"
    case addFeed = "add_feed"
    case addFeedDesc = "add_feed_desc"
    case cancel = "cancel"
    case deleteFeedMsg = "delete_feed_msg"
    case enterUrlPlaceholder = "enter_url_placeholder"
    case feedAlreadyExists = "feed_already_exists"
    case fetchDataFailed = "fetch_data_failed"
    case genericErrorMessage = "error_occurred_try_again"
    case noData = "no_data"
    case noInternet = "no_internet_connection"
    case ok = "ok"
    case rssFeeds = "rss_feeds"
    case rssFeedsDesc = "rss_feeds_desc"
    case yes = "yes"
                
    var localized: String {
        return self.rawValue.localized()
    }
}


//  MARK: - AppUrls
struct AppUrls {
    private init() {}
    
    static let baseUrl      = "https://"
    static let login        = "api/v1/users/login"
    static let user         = "users/me"    
}


//  MARK: - AppKeys
enum AppKeys: String {
    case email = "email"
    case password = "password"
}


//  MARK: - HTTPCode
enum HTTPCode: Int {
    case notAuthorized = 401
    case notFound = 404
    
    func message() -> String {
        switch self {
        case .notAuthorized:
            return ""
        case .notFound:
            return ""
        }
    }
    
    func title() -> String {
        switch self {
        case .notAuthorized:
            return ""
        case .notFound:
            return ""
        }
    }
}


//  MARK: - AppError
enum AppError: Error {
    case genericError
    case noData
    case noInternet
    case fetchDataError
    case feedAlreadyExists
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noData:
            return AppStrings.noData.rawValue
        case .noInternet:
            return AppStrings.noInternet.localized
        case .fetchDataError:
            return AppStrings.fetchDataFailed.localized
        case .feedAlreadyExists:
            return AppStrings.feedAlreadyExists.localized
        default:
            return AppStrings.genericErrorMessage.localized
        }
    }
}


//  MARK: - Typealiases
typealias JSON = [String: Any]





