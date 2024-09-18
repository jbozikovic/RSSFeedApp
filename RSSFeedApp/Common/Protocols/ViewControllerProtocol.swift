//
//  ViewControllerProtocol.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 27.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation

//  MARK: - ViewControllerProtocol
protocol ViewControllerProtocol: ViewStyleable, NavigationBarProtocol, ErrorHandlerProtocol, ActivityIndicatorPresentable {}
