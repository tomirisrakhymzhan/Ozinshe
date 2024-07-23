//
//  MovieCell.swift
//  Ozinshe
//
//  Created by Томирис Рахымжан on 04/07/2024.
//

import UIKit
import SDWebImage

class MovieCell: UITableViewCell {

    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var playView: UIView!
    
    @IBOutlet weak var watchLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(movie: Movie) {
        nameLabel.text = movie.name

        let genreName = movie.genres?.first?.name ?? "Unknown Genre"
        let categoryName = movie.categories?.first?.name ?? "Unknown Category"
        yearLabel.text = "\(movie.year!) • \(genreName) • \(categoryName)"
        
        if let posterLink = movie.poster?.link, let imageUrl = URL(string: posterLink) {
            posterImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"), options: .highPriority) { [weak self] image, error, cacheType, url in
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                } else {
                    print("Image loaded successfully from: \(url?.absoluteString ?? "No URL")")
                }
            }
        } else {
            posterImageView.image = UIImage(named: "placeholder")
        }
        watchLabel.text = "WATCH".localized()
       
        
    }
    
}
