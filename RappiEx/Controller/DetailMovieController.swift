//
//  DetailMovieController.swift
//  RappiEx
//
//  Created by Pablo Ramirez on 6/14/19.
//  Copyright © 2019 Pablo Ramirez. All rights reserved.
//

import UIKit

struct DetailMovies {
    var titleMovie: String
    var voteAverage: String
    var originalLanguage: String
    var overview: String
    var releaseDate: String
    
    var image: UIImage
}

class DetailMovieController: UIViewController {

    var detailMovie: DetailMovies?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var originalLanguageLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var barItem: UINavigationItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //navigationController?.navigationBar.topItem?.title = "Back"
        
        titleLabel.text = (detailMovie?.titleMovie)!
        imageMovie.image = (detailMovie?.image)!
        voteAverageLabel.text = (detailMovie?.voteAverage)!
        originalLanguageLabel.text = "Language: \((detailMovie?.originalLanguage)!)"
        releaseDateLabel.text = "Release Date: \((detailMovie?.releaseDate)!)"
        overviewLabel.text = (detailMovie?.overview)!
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
