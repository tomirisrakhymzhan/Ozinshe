//
//  MainPageViewController.swift
//  Ozinshe
//
//  Created by Томирис Рахымжан on 20/08/2024.
//

import UIKit
import SVProgressHUD

protocol MovieProtocol {
    func movieDidSelect(movie: Movie)
}


class MainPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MovieProtocol {

    @IBOutlet weak var tableView: UITableView!
    var mainMovies : [MainMovie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        
        addNavBarItem()
        downloadMainMovies()
    }
    
    func addNavBarItem(){
        let image = UIImage(named: "logoMainPage")
        let imageView = UIImageView(image: image)
        let uiImageItem = UIBarButtonItem.init(customView: imageView)
        navigationItem.leftBarButtonItem = uiImageItem
        
    }
    

    func downloadMainMovies() {
        SVProgressHUD.show()
        
        guard let url = URL(string: Urls.MOVIE_MAIN_URL) else {
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(Storage.sharedInstance.accessToken)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR: \(error.localizedDescription)")
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                DispatchQueue.main.async {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                }
                return
            }
            
            let statusCode = httpResponse.statusCode
            let resultString = String(data: data, encoding: .utf8) ?? ""
            
            if statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    let moviesResponse = try decoder.decode(MainMovies.self, from: data)
                    self.mainMovies = moviesResponse
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    DispatchQueue.main.async {
                        SVProgressHUD.showError(withStatus: "Failed to parse data: \(error.localizedDescription)")
                    }
                }
            } else {
                var errorString = "CONNECTION_ERROR".localized()
                errorString += " \(statusCode) \(resultString)"
                DispatchQueue.main.async {
                    SVProgressHUD.showError(withStatus: "\(errorString)")
                }
            }
        }
        
        task.resume()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 292
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainPageTableViewCell
        
        cell.setData(mainMovie: mainMovies[indexPath.row])
        cell.delegate = self
        return cell
    }
    

    func movieDidSelect(movie: Movie) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MovieInfoViewController") as! MovieInfoViewController
        vc.movie = movie
        navigationController?.pushViewController(vc, animated: true)
    }

}
