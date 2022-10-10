//
//  PodcastRequest.swift
//  ArabamAssignment
//
//  Created by Muhammed Karakul on 11.01.2022.
//

import Foundation

struct AllRequest: DataRequest {
    
    var searchText: String
    var media: String
    
    var baseURL: String {
        "https://itunes.apple.com"
    }
    
    var url: String {
        "/search"
    }
    
    var queryItems: [String : String] {
        ["term": searchText,
         "media" : media]
    }
    
    var method: HTTPMethod {
        .get
    }
    
    init(searchText: String, media: String) {
        self.searchText = searchText
        self.media = media
    }
    
    func decode(_ data: Data) throws -> AllModelResponse {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response = try decoder.decode(AllModelResponse.self, from: data)
        return response
    }
}
