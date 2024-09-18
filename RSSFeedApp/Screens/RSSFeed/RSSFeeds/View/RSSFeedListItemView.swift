//
//  RSSFeedListItemView.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 17.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct RSSFeedListItemView: View {
    let viewModel: RSSFeedListItemViewModel
    
    var body: some View {
        content
            .padding(.vertical, 8)
    }
}

//  MARK: - Content
private extension RSSFeedListItemView {
    var content: some View {
        HStack(alignment: .top, spacing: 12) {
            image
            VStack(spacing: 12) {
                titleView
                descriptionView
            }
            favoritesButton
            removeButton
        }
        .padding(.all, 12)
        .clipShape(RoundedRectangle(cornerRadius: AppUI.cornerRadius))
    }
        
    var image: some View {
        WebImage(url: viewModel.imageUrl) { image in
                image.resizable()
            } placeholder: {
                Rectangle().foregroundColor(.navyMint)
            }
            .onSuccess { image, data, cacheType in }
            .indicator(.activity) // Activity Indicator
            .transition(.fade(duration: 0.5))
            .scaledToFit()
            .frame(width: 100)
    }
    
    var titleView: some View {
        Text(viewModel.title)
            .font(Font.system(.title3, design: .default, weight: .bold))
            .foregroundStyle(Color.navyMint)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var descriptionView: some View {
        Text(viewModel.description)
            .font(AppUI.listBodyFont)
            .foregroundStyle(Color.navyMint)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var favoritesButton: some View {
        Button("", systemImage: viewModel.favoritesButtonImage) {
            viewModel.userTappedFavoritesButton()
        }
        .tint(.navyMint)
    }
    
    var removeButton: some View {
        Button("", systemImage: AppImages.remove.rawValue) {
            viewModel.userTappedRemoveButton()
        }
        .tint(.navyMint)
    }
}

//  MARK: - Preview
#Preview {
    RSSFeedListItemView(viewModel: RSSFeedListItemViewModel(rssFeed: RSSChannel()))
}
