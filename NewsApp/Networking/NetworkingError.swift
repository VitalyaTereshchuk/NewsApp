//
//  NetworkingError.swift
//  NewsApp
//
//  Created by Vitaly on 11.12.2023.
//

import Foundation

enum NetworkingError: Error {
    case networkingError(_ error: Error)
    case unknown
}
