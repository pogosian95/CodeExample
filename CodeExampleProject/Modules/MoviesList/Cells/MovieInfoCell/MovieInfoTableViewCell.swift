//
//  MovieInfoTableViewCell.swift
//  CodeExampleProject
//
//  Created by Oleg Pogosian on 21.10.2021.
//

import UIKit
import SDWebImage

protocol MovieInfoTableViewCellProtocol {
    func display(model: MovieInfoTableViewCell.MovieCellModel)
}

class MovieInfoTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    // MARK: Local Types
    struct MovieCellModel {
        var imagePath: String
        var title: String
        var description: String
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        resetContent()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetContent()
    }
     
    private func resetContent() {
        movieImageView.image = nil
        movieTitleLabel.text = nil
        movieDescriptionLabel.text = nil
    }
    
    private func setupView() {
        movieImageView.viewCorner(10)
    }
    
}

extension MovieInfoTableViewCell: MovieInfoTableViewCellProtocol {
    
    func display(model: MovieInfoTableViewCell.MovieCellModel) {
        movieImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500" + model.imagePath))
        movieTitleLabel.text = model.title
        movieDescriptionLabel.text = model.description
    }
    
}
