//
//  MoviesListPresenter.swift
//  CodeExampleProject
//
//  Created by Oleg Pogosian on 21.10.2021.
//

import Foundation

protocol MoviesListPresenterProtocol {
    init(view: MoviesListViewControllerProtocol)
    func getCellCount() -> Int
    func configurateCell(_ cell: MovieInfoTableViewCellProtocol, item: Int)
    func cellPressed(item: Int)
    func willDisplayCell(item: Int)
    func tableViewPulled()
}

class MoviesListPresenter: MoviesListPresenterProtocol {
    
    private unowned let view: MoviesListViewControllerProtocol

    required init(view: MoviesListViewControllerProtocol) {
        self.view = view
        self.getMovies()
    }
    
    // MARK: - Properties
    private var moviesList: [MovieModel] = []
    private var page = 1
    private var total = 0
    private let pageSize = 20 //default count of items return by api
    
    // MARK:  UI
    func getCellCount() -> Int {
        return moviesList.count
    }
    
    func configurateCell(_ cell: MovieInfoTableViewCellProtocol, item: Int) {
        let movie = moviesList[item]
        
        cell.display(model: MovieInfoTableViewCell.MovieCellModel(imagePath: movie.posterPath, title: movie.title, description: movie.overview))
    }
    
    // MARK: - Actions
    func cellPressed(item: Int) {
        DispatchQueue.main.async {
            let movieId = self.moviesList[item].id
            let vc = MovieDetailsViewController.instance(.movies)
            vc.presenter = MovieDetailsPresenter(view: vc, movieId: movieId)
            self.view.pushToVC(vc, animated: true)
        }
    }
    
    func willDisplayCell(item: Int) {
        if (item + 1).isMultiple(of: pageSize * page) && page * pageSize < total {
            self.page += 1
            
            getMovies()
        }
    }
    
    func tableViewPulled() {
        if page > 1 {
            page = 1
            getMovies()
        } else {
            self.view.stopRefreshing()
        }
    }
    
    // MARK: Business Logic
    private func getMovies() {
        let moviesApi = MoviesApi()
        if moviesList.isEmpty {
            self.view.startActivityIndicator()
        }
        
        moviesApi.getMovies(page: self.page) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let model):
                
                if self.page > 1 {
                    self.moviesList += model.results
                } else {
                    self.moviesList = model.results
                }
                
                self.total = model.totalResults
                self.view.reloadTable()
                self.view.stopRefreshing()
                DispatchQueue.main.async {
                    self.view.stopActivityIndicator()
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.view.stopActivityIndicator()
                }
            }
        }
    }
    
}
