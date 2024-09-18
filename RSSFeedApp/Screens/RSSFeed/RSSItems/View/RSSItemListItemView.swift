//
//  RSSItemListItemView.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 18.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct RSSItemListItemView: View {
    let viewModel: RSSItemListViewModel
    
    var body: some View {
        content
            .padding(.vertical, 8)
    }
    
    var content: some View {
        HStack(alignment: .top, spacing: 12) {
            image
            VStack(spacing: 12) {
                titleView
                descriptionView
            }
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
            .transition(.fade(duration: 0.5)) // Fade Transition with duration
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
}

struct RSSItemListItemView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            
        }
    }
}
