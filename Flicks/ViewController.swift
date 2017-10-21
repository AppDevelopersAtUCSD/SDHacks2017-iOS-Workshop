//
//  ViewController.swift
//  Flicks
//
//  Created by Tejen on 10/20/17.
//  Copyright © 2017 Tejen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var flicksTableView: UITableView!
    
    var movies: [NSDictionary]? {
        didSet {
            DispatchQueue.main.async {
                self.flicksTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        flicksTableView.dataSource = self
        
        loadMovieData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadMovieData() {
        // set up URLRequest with URL
        let endpoint = "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: endpoint)!
        let urlRequest = URLRequest(url: url)
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            // parse the result as JSON
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    self.movies = dataDictionary["results"] as! [NSDictionary]
                    print(self.movies)
                }
            }
        })
        task.resume()
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = flicksTableView.dequeueReusableCell(withIdentifier: "movieCell") as! MovieCell
        cell.movieTitle.text = movies![indexPath.row]["title"] as! String
        
        let image_base_url = "https://image.tmdb.org/t/p/w342"
        if let url = NSURL(string: image_base_url + (movies![indexPath.row]["poster_path"] as! String)) {
            if let data = NSData(contentsOf: url as URL) {
                cell.movieImage.image = UIImage(data: data as Data)
            }
        }

        return cell
    }
    
}
