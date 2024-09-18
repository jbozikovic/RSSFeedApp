//
//  AddRSSFeedView.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 17.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import SwiftUI

struct AddRSSFeedView: View {
    @ObservedObject var viewModel: AddRSSFeedViewViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, AppUI.defaultPadding)
            .background(Color.backgroundBase.ignoresSafeArea(.all))
    }
    
    var content: some View {
        VStack(alignment: .center, spacing: 32) {
            descriptionView
            textFieldView
            button
        }
    }
}

private extension AddRSSFeedView {
    var descriptionView: some View {
        Text(AppStrings.addFeedDesc.localized)
            .font(Font.system(size: 16.0))
            .foregroundStyle(Color.navyMint)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    var textFieldView: some View {
        TextField(AppStrings.enterUrlPlaceholder.localized, text: $viewModel.feedUrl)
            .keyboardType(.URL)
            .padding(10.0)
            .foregroundStyle(.gray)
            .background(.navyMint)
            .clipShape(RoundedRectangle(cornerRadius: AppUI.cornerRadius))
    }
    
    var button: some View {
        Button(AppStrings.add.localized) {
            viewModel.userTappedAddFeedButton()
            dismiss()
        }
        .font(Font.system(size: 20))
        .tint(.white)
        .padding(.vertical, 16)
        .padding(.horizontal, 32)
        .background(Color.green)
        .clipShape(RoundedRectangle(cornerRadius: AppUI.cornerRadius))
        .disabled(!viewModel.isSubmitEnabled)
    }
}

#Preview {
    AddRSSFeedView(viewModel: AddRSSFeedViewViewModel())
}
