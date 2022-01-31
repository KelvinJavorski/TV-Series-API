//
//  QueryService.swift
//  IOS Challenge - TV API
//
//  Created by Kelvin Javorski Soares on 31/01/22.
//

import Foundation

class QueryService {
    let defaultSession = URLSession(configuration: .default)
    
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
    var shows: [Show] = []
    
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = ([Show]?, String) -> Void
    
    func getSearchResults(searchTerm: String, completion: @escaping QueryResult) {
        DispatchQueue.main.async {
            completion(self.shows, self.errorMessage)
        }
    }
}
