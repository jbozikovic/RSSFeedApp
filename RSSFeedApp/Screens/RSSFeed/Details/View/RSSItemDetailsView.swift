//
//  RSSItemDetailsView.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 16.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import SwiftUI
import WebKit
import SDWebImageSwiftUI

struct RSSItemDetailsView: View {
    @ObservedObject var viewModel: RSSItemDetailsViewModel
    
    var body: some View {
        WebView(url: viewModel.url)
            .padding(.horizontal, AppUI.defaultPadding)
            .background(Color.backgroundBase.ignoresSafeArea(.all))
    }
}

#Preview {
    RSSItemDetailsView(viewModel: RSSItemDetailsViewModel(rssItem: RSSItem()))
}

//  MARK: - WebView
struct WebView: UIViewRepresentable {
    let webView: WKWebView
    let url: String
    
    init(url: String) {
        webView = WKWebView(frame: .zero)
        self.url = url
    }
    
    func makeUIView(context: Context) -> WKWebView {
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = self.url.toURL else { return }
        webView.load(URLRequest(url: url))
    }
}
