//
//  TableCollectionViewSection.swift
//  NewsApp
//
//  Created by Vitaly on 18.12.2023.
//

import Foundation

protocol TableCollectionViewItemsProtocol { }

struct TableCollectionViewSection {
    var title: String?
    var items: [TableCollectionViewItemsProtocol]
}
