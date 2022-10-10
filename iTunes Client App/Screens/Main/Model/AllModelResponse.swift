//
//  PodcastResponse.swift
//  iTunes Client App
//
//  Created by Pazarama iOS Bootcamp on 1.10.2022.
//

import Foundation

struct AllModelResponse: Decodable {
    let resultCount: Int?
    let results: [AllModel]?
}
