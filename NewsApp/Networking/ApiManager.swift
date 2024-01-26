//
//  ApiManager.swift
//  NewsApp
//
//  Created by Vitaly on 11.12.2023.
//

import Foundation

final class ApiManager {
    enum Category: String {
        case general = "general"
        case business = "business"
        case technology = "technology"
    }
    
    private static let apiKey = "" // News_API_Key
    private static let baseUrl  = "https://newsapi.org/v2/"
    private static let path = "top-headlines"
    
    //MARK: - Create url path and make request
    static func getNews(from category: Category,
                        page: Int,
                        searchText: String?,
                        completion: @escaping (Result<[ArticleResponceObject], Error>) -> ()) {
        
        var searchParameter: String = ""
        if let searchText = searchText {
            searchParameter = "&q=\(searchText)"
        }
        
        let stringUrl = baseUrl + path + "?category=\(category.rawValue)&language=en" + searchParameter + "&apiKey=\(apiKey)"
        
        guard let url = URL(string: stringUrl) else { return }
        
        let session = URLSession.shared.dataTask(with: url) { data, _, error in
            handleResponse(data: data,
                           error: error,
                           completion: completion)
        }
        session.resume()
    }
    
    static func getImageData(url: String,
                             completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                completion(.success(data))
            }
            if let error = error {
                completion(.failure(error))
            }
        }
        session.resume()
    }
    
    //MARK: - Handle responce
    private static func handleResponse(data: Data?,
                                       error: Error?,
                                       completion: @escaping (Result<[ArticleResponceObject], Error>) -> ()) {
        if let error = error {
            completion(.failure(NetworkingError.networkingError(error)))
        } else if let data = data {
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            print(json ?? "")
            do {
                let model = try JSONDecoder().decode(NewsResponseObject.self,
                                                     from: data)
                completion(.success(model.articles))
            }
            catch let decodeError{
                completion(.failure(decodeError))
            }
        } else {
            completion(.failure(NetworkingError.unknown))
        }
    }
}
