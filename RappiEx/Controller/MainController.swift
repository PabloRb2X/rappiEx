//
//  ViewController.swift
//  RappiEx
//
//  Created by Pablo Ramirez on 6/13/19.
//  Copyright © 2019 Pablo Ramirez. All rights reserved.
//

import UIKit
import ApiTheMovieDB

class MainController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var popularMovies: MoviesResponse?
    var topRatedMovies: MoviesResponse?
    var upcomingMovies:  MoviesResponse?
    
    let moviesViewModel: ServiceViewModel = ServiceViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Movie App"
        
        mainCollectionView.register(UINib(nibName: "MainCell", bundle: nil), forCellWithReuseIdentifier: "myCell")
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        if let layout = mainCollectionView.collectionViewLayout as?
            UICollectionViewFlowLayout{
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        getMoviesCollection()
    }
    
    func getMoviesCollection(){
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if popularMovies == nil{
                startService(type: "popular")
            }
            else{
                DispatchQueue.main.async {
                    self.mainCollectionView.reloadData()
                }
            }
        case 1:
            if topRatedMovies == nil{
                startService(type: "top_rated")
            }
            else{
                DispatchQueue.main.async {
                    self.mainCollectionView.reloadData()
                }
            }
        case 2:
            if upcomingMovies == nil{
                startService(type: "upcoming")
            }
            else{
                DispatchQueue.main.async {
                    self.mainCollectionView.reloadData()
                }
            }
        default:
            
            break
        }
        
    }
    
    func startService(type: String){
        self.showLoadingView()
        
        moviesViewModel.performMoviesService(typeMovies: type)
        moviesViewModel.onSuccessMoviesService = {(_ response: MoviesResponse) -> Void in
            self.dismissLoadingView()
            
            print("respuesta recibida")
            
            switch type {
            case "popular":
                self.popularMovies = response
            case "top_rated":
                self.topRatedMovies = response
            case "upcoming":
                self.upcomingMovies = response
            default:
                break
            }
            
            DispatchQueue.main.async {
                
                self.mainCollectionView.reloadData()
            }
        }
        moviesViewModel.onServiceError = {(_ error: ServiceError)  -> Void in
            self.dismissLoadingView()
            
            print("Error en el servicio")
        }
    }
    
    @IBAction func segmentedControlEvent(_ sender: UISegmentedControl) {
        
        getMoviesCollection()
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    func downloadImage(from url: URL, imageView: UIImageView) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            //print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                imageView.image = UIImage(data: data)
            }
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let detailController = segue.destination as? DetailMovieController{
//
//        }
//    }
}

extension MainController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailController = DetailMovieController()
        
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            detailController.detailMovie = DetailMovies(titleMovie: popularMovies?.results[indexPath.row].title, voteAverage: "\(String(describing: popularMovies?.results[indexPath.row].voteAverage))", originalLanguage: popularMovies?.results[indexPath.row].originalLanguage, overview: popularMovies?.results[indexPath.row].overview, releaseDate: popularMovies?.results[indexPath.row].releaseDate)
        case 1:
            detailController.detailMovie = DetailMovies(titleMovie: topRatedMovies?.results[indexPath.row].title, voteAverage: "\(String(describing: topRatedMovies?.results[indexPath.row].voteAverage))", originalLanguage: topRatedMovies?.results[indexPath.row].originalLanguage, overview: topRatedMovies?.results[indexPath.row].overview, releaseDate: topRatedMovies?.results[indexPath.row].releaseDate)
        case 2:
            detailController.detailMovie = DetailMovies(titleMovie: upcomingMovies?.results[indexPath.row].title, voteAverage: "\(String(describing: upcomingMovies?.results[indexPath.row].voteAverage))", originalLanguage: upcomingMovies?.results[indexPath.row].originalLanguage, overview: upcomingMovies?.results[indexPath.row].overview, releaseDate: upcomingMovies?.results[indexPath.row].releaseDate)
        default:
            break
        }
        
        self.navigationController?.pushViewController(detailController, animated: true)
    }
}

extension MainController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return popularMovies?.results.count ?? 0
        case 1:
            return topRatedMovies?.results.count ?? 0
        case 2:
            return upcomingMovies?.results.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? MainCell{
            
            var title: String = ""
            var posterPath: String = ""
            var voteAverage: Double = 0.0
            
            switch segmentedControl.selectedSegmentIndex{
            case 0:
                title = popularMovies?.results[indexPath.row].title ?? ""
                posterPath = popularMovies?.results[indexPath.row].posterPath ?? ""
                voteAverage = popularMovies?.results[indexPath.row].voteAverage ?? 0.0
            case 1:
                title = topRatedMovies?.results[indexPath.row].title ?? ""
                posterPath = topRatedMovies?.results[indexPath.row].posterPath ?? ""
                voteAverage = topRatedMovies?.results[indexPath.row].voteAverage ?? 0.0
            case 2:
                title = upcomingMovies?.results[indexPath.row].title ?? ""
                posterPath = upcomingMovies?.results[indexPath.row].posterPath ?? ""
                voteAverage = upcomingMovies?.results[indexPath.row].voteAverage ?? 0.0
            default:
                return cell
            }
            
            cell.titleLabel.text = title
            cell.rankingLabel.text = "\(voteAverage)"
            
            if let url = URL(string: "https://image.tmdb.org/t/p/w185\(posterPath)"){
                downloadImage(from: url, imageView: cell.movieImage)
            }
            //cell.movieImage.image = UIImage(named: "testImage")
            
            return cell
        }
        else{
            return UICollectionViewCell()
        }
    }
}

extension MainController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: mainCollectionView.frame.width * 0.48, height: mainCollectionView.frame.height * 0.5)
    }

}

extension UIViewController{
    public func showLoadingView(){
        self.view.endEditing(true)
        let loadingView = LoadingView()
        loadingView.tag = 500
        //loadingView.alpha = 0.5
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        loadingView.frame = CGRect.init(x: keyWindow.bounds.origin.x, y: keyWindow.bounds.origin.y, width: keyWindow.bounds.size.width, height: keyWindow.bounds.size.height)
        UIView.animate(withDuration: 1) {
            keyWindow.rootViewController?.view.isUserInteractionEnabled = false
            keyWindow.addSubview(loadingView)
        }
    }
    
    public func dismissLoadingView(){
        if let viewWithTag = UIApplication.shared.keyWindow?.viewWithTag(500) {
            UIApplication.shared.keyWindow?.rootViewController?.view.isUserInteractionEnabled = true
            viewWithTag.removeFromSuperview()
        }
    }
}
