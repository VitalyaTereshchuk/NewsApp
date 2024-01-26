//
//  GeneralViewModel.swift
//  NewsApp
//
//  Created by Vitaly on 09.12.2023.
//

import Foundation

final class GeneralViewModel: NewsListViewModel {
    //TODO: Load Data
    override func loadData(searchText: String?) {
        super.loadData(searchText: searchText)
        ApiManager.getNews(from: .general,
                           page: page,
                           searchText: searchText) { [ weak self ] result in
            self?.handleResult(result)
        }
    }
}
