//
//  ViewController.swift
//  RappiEx
//
//  Created by Pablo Ramirez on 6/13/19.
//  Copyright © 2019 Pablo Ramirez. All rights reserved.
//

import UIKit
import ApiTheMovieDB

let userdefaults: UserDefaults = UserDefaults()

class MainController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var popularMovies: MoviesResponse?
    var topRatedMovies: MoviesResponse?
    var upcomingMovies:  MoviesResponse?
    
    var searchMovies: SearchMovieResponse?
    var isSearching = false
    
    let moviesViewModel: ServiceViewModel = ServiceViewModel()
    
    var filter: [Result] = []
    var isFilter = false
    
    var refresher: UIRefreshControl!
    
    var detailMovie: DetailMovies!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //self.title = "Movie App"
        
        mainCollectionView.register(UINib(nibName: "MainCell", bundle: nil), forCellWithReuseIdentifier: "myCell")
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        refresher = UIRefreshControl()
        mainCollectionView.alwaysBounceVertical = true
        refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        mainCollectionView.addSubview(refresher)
        
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
    
    @objc func loadData(){
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            popularMovies = nil
        case 1:
            topRatedMovies = nil
        case 2:
            upcomingMovies = nil
        default:
            break
        }
        
        getMoviesCollection()
        stopRefresher()
    }
    
    func stopRefresher() {
        self.refresher.endRefreshing()
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
            segmentedControl.selectedSegmentIndex = 0
            if popularMovies == nil{
                startService(type: "popular")
            }
            else{
                DispatchQueue.main.async {
                    self.mainCollectionView.reloadData()
                }
            }
            break
        }
    }
    
    func searchService(text: String){
        
        if text.isEmpty{
            return
        }
        
        isSearching = true
        self.showLoadingView()
        
        moviesViewModel.performSearchMovieService(movie: text)
        moviesViewModel.onSuccessSearchMovieService = {(_ response: SearchMovieResponse) -> Void in
            self.dismissLoadingView()
            
            self.searchMovies = response
            
            self.segmentedControl.selectedSegmentIndex = -1
            
            DispatchQueue.main.async {
                
                self.mainCollectionView.reloadData()
            }
        }
        moviesViewModel.onServiceError = {(_ error: ServiceError)  -> Void in
            self.dismissLoadingView()
            
            print("Error en el servicio")
            self.showErrorConectionAlert(message: "Verifica tu conexión a internet.")
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
                
                self.saveObject(nameObject: "popularMovies", response: self.popularMovies!)
            case "top_rated":
                self.topRatedMovies = response
                
                self.saveObject(nameObject: "topRatedMovies", response: self.topRatedMovies!)
            case "upcoming":
                self.upcomingMovies = response
                
                self.saveObject(nameObject: "upcomingMovies", response: self.upcomingMovies!)
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
            
            switch self.segmentedControl.selectedSegmentIndex {
            case 0:
                if let popularMoviesObject = userdefaults.object(forKey: "popularMovies") as? MoviesResponse{
                    self.popularMovies = popularMoviesObject
                    
                    self.mainCollectionView.reloadData()
                }
            case 1:
                if let topRatedMoviesObject = userdefaults.object(forKey: "topRatedMovies") as? MoviesResponse{
                    self.topRatedMovies = topRatedMoviesObject
                    
                    self.mainCollectionView.reloadData()
                }
            case 2:
                if let upcomingMoviesObject = userdefaults.object(forKey: "upcomingMovies") as? MoviesResponse{
                    self.upcomingMovies = upcomingMoviesObject
                    
                    self.mainCollectionView.reloadData()
                }
            default:
                print("")
            }
        }
    }
    
    @IBAction func segmentedControlEvent(_ sender: UISegmentedControl) {
        isSearching = false
        searchMovies = nil
        
        searchBar.text = ""
        isFilter = false
        filter.removeAll()
        
        getMoviesCollection()
    }

    func saveObject(nameObject: String, response: MoviesResponse){
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: response, requiringSecureCoding: false)
            
            userdefaults.set(data, forKey: nameObject)
        }
        catch let error{
            print(error)
        }
        
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
    
    @IBAction func searchOnlineAction(_ sender: Any) {
        let alert = UIAlertController(title: "Búsqueda Online", message: "Escribe el nombre de la película a buscar", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Buscar", style: .default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
            let textField = alert.textFields!.first
                                        
            self.searchService(text: textField?.text ?? "")
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default) { (action: UIAlertAction) -> Void in
            
        }
        
        alert.addTextField { (textField: UITextField) -> Void in
            
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showErrorConectionAlert(message: String){
         let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailController = segue.destination as? DetailMovieController{
            detailController.detailMovie = detailMovie
        }
    }
}

extension MainController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? MainCell else {return}
        
        //let detailController = DetailMovieController()
        
        if isSearching{
            detailMovie = DetailMovies(titleMovie: searchMovies?.results[indexPath.row].title ?? "", voteAverage: "\(String(describing: searchMovies?.results[indexPath.row].voteAverage ?? 0.0))", originalLanguage: searchMovies?.results[indexPath.row].originalLanguage ?? "", overview: searchMovies?.results[indexPath.row].overview ?? "", releaseDate: searchMovies?.results[indexPath.row].releaseDate ?? "", image: cell.movieImage.image!)
        }
        else{
            switch segmentedControl.selectedSegmentIndex{
            case 0:
                detailMovie = DetailMovies(titleMovie: popularMovies?.results[indexPath.row].title ?? "", voteAverage: "\(String(describing: popularMovies?.results[indexPath.row].voteAverage ?? 0.0))", originalLanguage: popularMovies?.results[indexPath.row].originalLanguage ?? "", overview: popularMovies?.results[indexPath.row].overview ?? "", releaseDate: popularMovies?.results[indexPath.row].releaseDate ?? "", image: cell.movieImage.image!)
            case 1:
                detailMovie = DetailMovies(titleMovie: topRatedMovies?.results[indexPath.row].title ?? "", voteAverage: "\(String(describing: topRatedMovies?.results[indexPath.row].voteAverage ?? 0.0))", originalLanguage: topRatedMovies?.results[indexPath.row].originalLanguage ?? "", overview: topRatedMovies?.results[indexPath.row].overview ?? "", releaseDate: topRatedMovies?.results[indexPath.row].releaseDate ?? "", image: cell.movieImage.image!)
            case 2:
                detailMovie = DetailMovies(titleMovie: upcomingMovies?.results[indexPath.row].title ?? "", voteAverage: "\(String(describing: upcomingMovies?.results[indexPath.row].voteAverage ?? 0.0))", originalLanguage: upcomingMovies?.results[indexPath.row].originalLanguage ?? "", overview: upcomingMovies?.results[indexPath.row].overview ?? "", releaseDate: upcomingMovies?.results[indexPath.row].releaseDate ?? "", image: cell.movieImage.image!)
            default:
                
                break
            }
        }
        
        //self.navigationController?.pushViewController(detailController, animated: true)
        self.performSegue(withIdentifier: "detailSegue", sender: nil)
    }
}

extension MainController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFilter{
            return filter.count
        }
        
        if isSearching{
            return searchMovies?.results.count ?? 0
        }
        
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
            
            if isFilter{
                title = filter[indexPath.row].title
                posterPath = filter[indexPath.row].posterPath
                voteAverage = filter[indexPath.row].voteAverage
            }
            else if isSearching{
                title = searchMovies?.results[indexPath.row].title ?? ""
                posterPath = searchMovies?.results[indexPath.row].posterPath ?? ""
                voteAverage = searchMovies?.results[indexPath.row].voteAverage ?? 0.0
            }
            else{
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

extension MainController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isFilter = true
        
        if searchBar.text != ""{
            
            if isSearching{
                filter = searchMovies?.results.filter{ $0.title.contains(searchBar.text!) } ?? []
            }
            else{
                switch segmentedControl.selectedSegmentIndex{
                case 0:
                    filter = popularMovies?.results.filter{ $0.title.contains(searchBar.text!) } ?? []
                case 1:
                    filter = topRatedMovies?.results.filter{ $0.title.contains(searchBar.text!) } ?? []
                case 2:
                    filter = upcomingMovies?.results.filter{ $0.title.contains(searchBar.text!) } ?? []
                default:
                    break
                }
            }
            
            
            mainCollectionView.reloadData()
        }
        else{
            isFilter = false
            filter.removeAll()
            
            getMoviesCollection()
        }
        
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
