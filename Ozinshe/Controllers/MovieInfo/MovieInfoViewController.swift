//
//  MovieInfoViewController.swift
//  Ozinshe
//
//  Created by Томирис Рахымжан on 27/07/2024.
//

import UIKit

class MovieInfoViewController: UIViewController {

    var movie : Movie?

    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let movie = movie {
            titleLabel.text = movie.name
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
