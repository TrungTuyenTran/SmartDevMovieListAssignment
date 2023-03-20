//
//  MovieItemCell.swift
//  MovieListSmartDevAssignment-Swift
//
//  Created by Tran Tuyen on 20/03/2023.
//

import UIKit

class MovieItemCell: UICollectionViewCell {
    
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        moviePosterImageView.image = nil
    }
    
    func setData(_ movie: MovieModel) {
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        movieTitleLabel.text = movie.title
        movieYearLabel.text = movie.year
        moviePosterImageView.contentMode = .scaleAspectFill
        moviePosterImageView.setImage(movie.poster ?? "")
    }
    
}
