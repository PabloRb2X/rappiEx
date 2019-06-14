//
//  DetailMovieController.swift
//  RappiEx
//
//  Created by Pablo Ramirez on 6/14/19.
//  Copyright © 2019 Pablo Ramirez. All rights reserved.
//

import UIKit

struct DetailMovies {
    var titleMovie: String?
    var voteAverage: String?
    var originalLanguage: String?
    var overview: String?
    var releaseDate: String?
}

class DetailMovieController: UIViewController {

    var detailMovie: DetailMovies?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Atrás"
        
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
