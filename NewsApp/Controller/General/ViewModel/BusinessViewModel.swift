//
//  BusinessViewModel.swift
//  NewsApp
//
//  Created by Vitaly on 14.12.2023.
//

import Foundation

final class BusinessViewModel: NewsListViewModel {
    //TODO: Load Data
    override func loadData(searchText: String?) {
        super.loadData(searchText: searchText)
        ApiManager.getNews(from: .business,
                           page: page,
                           searchText: searchText) { [ weak self ] result in
            self?.handleResult(result)
        }
    }
    
    override func convertToCellViewModel(_ articles: [ArticleResponceObject]) {
        var viewModels = articles.map {ArticleCellViewModel(article: $0)}
        
        if sections.isEmpty {
            let firstSection = TableCollectionViewSection(items: [viewModels.removeFirst()])
            let secondSection = TableCollectionViewSection(items: viewModels)
            
            sections = [firstSection, secondSection ]
        } else {
            sections[1].items += viewModels
        }
    }
}
