//
//  RSSItemsView.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 16.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct RSSItemsView: View {
    @ObservedObject var viewModel: RSSItemsViewModel
    
    var body: some View {
        content
            .padding(.horizontal, AppUI.defaultPadding)
            .background(Color.backgroundBase.ignoresSafeArea(.all))
    }
}

//  MARK: - Content view
private extension RSSItemsView {
    var content: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                itemsList
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
    
    var itemsList: some View {
        LazyVStack(spacing: 4) {
            ForEach(viewModel.cellViewModels, id: \.url) { rssItem in
                RSSItemListItemView(viewModel: rssItem)
                    .background(Color.navyLight)
                    .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .listRowSeparator(.visible)
                    .clipShape(RoundedRectangle(cornerRadius: AppUI.cornerRadius))
                    .onTapGesture {
                        viewModel.userTappedItem(rssItem: rssItem.rssItem)
                    }
            }
        }
    }
}


#Preview {
    RSSItemsView(viewModel: RSSItemsViewModel(rssItems: []))
}






