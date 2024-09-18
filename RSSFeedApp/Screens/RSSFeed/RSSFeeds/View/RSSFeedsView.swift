//
//  RSSFeedsView.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 14.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct RSSFeedsView: View {
    @ObservedObject var viewModel: RSSFeedsViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 24.0) {
            if viewModel.showEmptyView {
                emptyView
            } else {
                content
            }
        }
        .padding(.horizontal, AppUI.defaultPadding)
        .background(Color.backgroundBase.ignoresSafeArea(.all))
        .onAppear {
            viewModel.loadData()
        }
        .alert(viewModel.error?.localizedDescription ?? AppStrings.genericErrorMessage.localized, isPresented: $viewModel.showError) {
            Button(AppStrings.ok.localized, role: .cancel) {
                viewModel.error = nil
            }
        }
        .actionSheet(isPresented: $viewModel.showDeleteConfirmation) {
            ActionSheet(title: Text(AppStrings.deleteFeedMsg.localized), buttons: [
                .destructive(Text(AppStrings.yes.localized), action: {
                    viewModel.userConfirmedFeedDeletion()
                }),
                .cancel({})
            ])
        }
    }
}

//  MARK: - Content view
private extension RSSFeedsView {
    var content: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                titleView
                feedsList
                button
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
    
    var titleView: some View {
        Text(viewModel.title)
            .font(Font.system(.title, design: .default, weight: .bold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    var descriptionView: some View {
        Text(viewModel.description)
            .font(Font.system(size: 16.0))
            .foregroundStyle(Color.navyMint)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    var button: some View {
        Button(AppStrings.addFeed.localized) {
            viewModel.didTapAddButton.send()
        }
        .font(Font.system(size: 20))
        .tint(.white)
        .padding(.vertical, 16)
        .padding(.horizontal, 32)
        .background(Color.green)
        .clipShape(RoundedRectangle(cornerRadius: AppUI.cornerRadius))
    }
    
    var feedsList: some View {
        LazyVStack(spacing: 4) {
            ForEach(viewModel.cellViewModels, id: \.url) { rssFeed in
                RSSFeedListItemView(viewModel: rssFeed)
                    .background(Color.navyLight)
                    .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .listRowSeparator(.visible)
                    .clipShape(RoundedRectangle(cornerRadius: AppUI.cornerRadius))
                    .onTapGesture {
                        viewModel.userTappedOnRSSFeedListItem(feed: rssFeed.rssFeed)
                    }
            }
        }
    }
}

//  MARK: - Empty view
private extension RSSFeedsView {
    var emptyView: some View {
        VStack(spacing: 32) {
            Spacer()
            titleView
            descriptionView
            button
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

//  MARK: - Preview
#Preview {
    let repository = RSSFeedRepository(apiService: RSSFeedAPIService(networkLayerService: NetworkLayerService()),
                                       dbService: RSSFeedDBService(coreDataService: CoreDataService()),
                                       parser: RSSParserService())
    let viewModel = RSSFeedsViewModel(repository: repository)
    RSSFeedsView(viewModel: viewModel)
}












