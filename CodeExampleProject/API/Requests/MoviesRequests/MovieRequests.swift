//
//  MovieRequesrs.swift
//  CodeExampleProject
//
//  Created by Oleg Pogosian on 21.10.2021.
//

import Alamofire


class MoviesApi: RestClient {
    
    func getMovies(page: Int, resp: @escaping IdParsingBlock<GetMoviesResponse>) {
        let url = baseUrl + MovieRequests.topRated
        
        var params: Parameters = [:]
        params["api_key"] = "f910e2224b142497cc05444043cc8aa4"
        params["page"] = page
        
        http.queryBy(url, parameters: params) { (response) in
            self.response(response, modelType: GetMoviesResponse.self, resp: resp, url: url)
        }
    }
    
    func getMovieBy(id: Int, resp: @escaping IdParsingBlock<MovieModel>) {
        
        let url = baseUrl + MovieRequests.movie + "\(id)"
        
        let params: Parameters = ["api_key": "f910e2224b142497cc05444043cc8aa4"]
        
        http.queryBy(url, parameters: params) { (response) in
            self.response(response, modelType: MovieModel.self, resp: resp, url: url)
        }
    }
    
}
