//
//  FavoriteTableViewController.swift
//  Ozinshe
//
//  Created by Томирис Рахымжан on 09/06/2024.
//

import UIKit
import SVProgressHUD

class FavoriteTableViewController: UITableViewController {

    var favorite: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let MovieCelNib = UINib(nibName: "MovieCell", bundle: nil)
        tableView.register(MovieCelNib, forCellReuseIdentifier: "MovieCell")
        downloadFavorites()

    }
    
    func downloadFavorites() {
        // Show the progress HUD
        SVProgressHUD.show()

        // Prepare the request
        guard let url = URL(string: Urls.FAVORITE_URL) else {
            SVProgressHUD.showError(withStatus: "Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(Storage.sharedInstance.accessToken)", forHTTPHeaderField: "Authorization")

        // Create a URLSession data task
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            // Ensure the progress HUD is dismissed
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }

            // Handle any errors
            if let error = error {
                DispatchQueue.main.async {
                    SVProgressHUD.showError(withStatus: "Error: \(error.localizedDescription)")
                }
                return
            }

            // Ensure we have received data
            guard let data = data else {
                DispatchQueue.main.async {
                    SVProgressHUD.showError(withStatus: "No data received")
                }
                return
            }

            // Check the response status code
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Decode the JSON response into an array of Movie objects
                do {
                    let decoder = JSONDecoder()
                    let movies = try decoder.decode(Movies.self, from: data)
                    
                    // Update the UI on the main thread
                    DispatchQueue.main.async {
                        self?.favorite = movies
                        self?.tableView.reloadData()
                    }
                } catch {
                    DispatchQueue.main.async {
                        SVProgressHUD.showError(withStatus: "Decoding error: \(error.localizedDescription)")
                    }
                }
            } else {
                // Handle non-200 HTTP responses
                var errorMessage = "CONNECTION_ERROR"
                if let httpResponse = response as? HTTPURLResponse {
                    errorMessage += " \(httpResponse.statusCode)"
                }
                if let resultString = String(data: data, encoding: .utf8) {
                    errorMessage += " \(resultString)"
                }
                DispatchQueue.main.async {
                    SVProgressHUD.showError(withStatus: errorMessage)
                }
            }
        }

        task.resume()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favorite.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        cell.setData(movie: favorite[indexPath.row])
        
        // Configure the cell...
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 153
    }

}
