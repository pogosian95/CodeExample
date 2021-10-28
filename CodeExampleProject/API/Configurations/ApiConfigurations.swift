//
//  ApiConfigurations.swift
//  CodeExampleProject
//
//  Created by Oleg Pogosian on 21.10.2021.
//

import Foundation

struct BaseRequests {
    static let baseURL = "https://api.themoviedb.org/3"
}

struct MovieRequests {
    static let movie = "/movie/"
    static let topRated = "/movie/top_rated"
}
