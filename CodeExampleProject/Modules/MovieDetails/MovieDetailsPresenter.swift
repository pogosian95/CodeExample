//
//  MovieDetailsPresenter.swift
//  CodeExampleProject
//
//  Created by Oleg Pogosian on 21.10.2021.
//

import Foundation

protocol MovieDetailsPresenterProtocol {
    init(view: MovieDetailsViewControllerProtocol, movieId: Int)
}

class MovieDetailsPresenter: MovieDetailsPresenterProtocol {
    
    private unowned let view: MovieDetailsViewControllerProtocol
    
    required init(view: MovieDetailsViewControllerProtocol, movieId: Int) {
        self.view = view
        self.movieId = movieId
        self.getMovieInfo()
    }
    
    // MARK: - Properties
    private var movieId = 0
    private var movie: MovieModel?
    
    // MARK:  UI
    private func configurateUI() {
        guard let model = movie else { return }
        
        self.view.display(model: MovieDetailsViewController.MovieDataVCModel(imagePath: model.backdropPath, rate: model.voteAverage, title: model.title, description: model.overview))
        
        DispatchQueue.main.async {
            self.view.stopActivityIndicator()
        }
    }
    
    // MARK: Business Logic
    func getMovieInfo() {
        let moviesApi = MoviesApi()
        
        self.view.startActivityIndicator()
        moviesApi.getMovieBy(id: movieId) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let model):
                self.movie = model
                self.configurateUI()
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.view.stopActivityIndicator()
                }
            }
        }
    }
    
}
