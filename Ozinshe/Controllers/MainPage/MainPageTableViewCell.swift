//
//  MainPageTableViewCell.swift
//  Ozinshe
//
//  Created by Томирис Рахымжан on 20/08/2024.
//

import UIKit
import SDWebImage

class TopAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)?
            .map { $0.copy() } as? [UICollectionViewLayoutAttributes]
        
        attributes?
            .reduce([CGFloat: (CGFloat, [UICollectionViewLayoutAttributes])]()) {
                guard $1.representedElementCategory == .cell else { return $0 }
                return $0.merging([ceil($1.center.y): ($1.frame.origin.y, [$1])]) {
                    ($0.0 < $1.0 ? $0.0 : $1.0, $0.1 + $1.1)
                }
            }
            .values.forEach { minY, line in
                line.forEach {
                    $0.frame = $0.frame.offsetBy(
                        dx: 0,
                        dy: minY - $0.frame.origin.y
                    )
                }
            }
        
        return attributes
    }
}

class MainPageTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var seeAllLabel: UILabel!
    
    var mainMovie : MainMovie?
    
    var delegate : MovieProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = TopAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24.0, bottom: 0, right: 24.0)
        layout.estimatedItemSize.width = 112
        layout.estimatedItemSize.height = 220
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        
   
    }

    func setData(mainMovie: MainMovie){
        categoryLabel.text = mainMovie.categoryName
        
        self.mainMovie = mainMovie
        seeAllLabel.text = "ALL".localized()
        
        collectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let movies = mainMovie?.movies else {
            return 0
        }
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainMoviesCollectionViewCell", for: indexPath)
        
        if let movies = mainMovie?.movies {
//            //Image
//            let transformer = SDImageResizingTransformer(size: CGSize(width: 112.0, height: 164.0),scaleMode: .aspectFill)
//            let imageview = cell.viewWithTag(1000) as! UIImageView
//            imageview.sd_setImage(with: URL(string: movies[indexPath.row].poster?.link ?? ""),placeholderImage: nil,context: [.imageTransformer : transformer])
//            imageview.layer.cornerRadius = 8.0
            let imageView = cell.viewWithTag(1000) as! UIImageView
            if let imageUrlString = movies[indexPath.row].poster?.link, let imageUrl = URL(string: imageUrlString) {
                URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
                    guard let data = data, let image = UIImage(data: data) else { return }
                    
                    // Resize and set the image
                    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 112.0, height: 164.0))
                    let resizedImage = renderer.image { _ in
                        image.draw(in: CGRect(origin: .zero, size: CGSize(width: 112.0, height: 164.0)))
                    }
                    
                    DispatchQueue.main.async {
                        imageView.image = resizedImage
                        imageView.layer.cornerRadius = 8.0
                        imageView.layer.masksToBounds = true
                    }
                }.resume()
            } else {
                imageView.image = UIImage(named: "placeholder")
            }

            
            //Name of movie
            let movieName = cell.viewWithTag(1001) as! UILabel
            movieName.text = movies[indexPath.row].name
            
            //Name of genre(first from genre array)
            let movieGenre = cell.viewWithTag(1002)as! UILabel
            if let genreItem =  movies[indexPath.row].genres?.first {
                movieGenre.text = genreItem.name
            }else{
                movieGenre.text = ""
            }
            
        }
        return cell

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let movies = mainMovie?.movies {
            delegate?.movieDidSelect(movie: movies[indexPath.item])
        }
    }
}
