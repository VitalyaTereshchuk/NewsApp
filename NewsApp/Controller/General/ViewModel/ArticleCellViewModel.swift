//""
//  ArticleCellViewModel.swift
//  NewsApp
//
//  Created by Vitaly on 09.12.2023.
//

import Foundation

final
class ArticleCellViewModel: TableCollectionViewItemsProtocol {
    let title: String
    let description: String
    let date: String
    var imageUrl: String?
    var imageData: Data?
    
    init(article: ArticleResponceObject) {
        title = article.title
        description = article.description ?? ""
        date = article.date
        imageUrl = article.urlToImage ?? ""
    }
}
