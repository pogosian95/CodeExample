//
//  MovieDetailsViewController.swift
//  CodeExampleProject
//
//  Created by Oleg Pogosian on 21.10.2021.
//

import UIKit
import SDWebImage

protocol MovieDetailsViewControllerProtocol: BaseViewControllerProtocol {
    func display(model: MovieDetailsViewController.MovieDataVCModel)
}

class MovieDetailsViewController: UIViewController {
        
    // MARK: - IBOutlets
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieRateLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    // MARK: Local Types
    struct MovieDataVCModel {
        var imagePath: String
        var rate: Double
        var title: String
        var description: String
    }
    
    // MARK: - Properties
    var presenter: MovieDetailsPresenterProtocol!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    // MARK: - UI
    private func setupViews() {
        movieImageView.viewCorner(20)
    }
    
}

extension MovieDetailsViewController: MovieDetailsViewControllerProtocol {

    func display(model: MovieDetailsViewController.MovieDataVCModel) {
        DispatchQueue.main.async {
            self.title = model.title
            self.movieImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500" + model.imagePath))
            self.movieRateLabel.text = "Rate: \(model.rate)"
            self.movieDescriptionLabel.text = model.description
        }
    }
    
}
