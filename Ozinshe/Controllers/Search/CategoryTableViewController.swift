//
//  CategoryTableViewController.swift
//  Ozinshe
//
//  Created by Томирис Рахымжан on 27/07/2024.
//

import UIKit
import SVProgressHUD

class CategoryTableViewController: UITableViewController {

    var categoryID = 0
    var categoryName = ""
    
    var movies: [Movie] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let backButton = UIBarButtonItem(image: UIImage(named: "BackButton"), style: .plain, target: self, action: #selector(backButtonClicked))
        backButton.tintColor = UIColor(named: "arrowColor")
        navigationItem.leftBarButtonItem = backButton

    }
    
    @objc func backButtonClicked(){
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let MovieCelNib = UINib(nibName: "MovieCell", bundle: nil)
        tableView.register(MovieCelNib, forCellReuseIdentifier: "MovieCell")
        
        self.title = categoryName
        downloadMoviesByCategories()
        
        
        if let backButtonImage = UIImage(named: "BackButton") {
            navigationController?.navigationBar.backIndicatorImage = backButtonImage
            navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
            navigationController?.navigationBar.topItem?.title = ""
            navigationController?.navigationBar.tintColor = UIColor(red: 0.07, green: 0.09, blue: 0.15, alpha: 1.00)
        }
    }

    func downloadMoviesByCategories() {
        SVProgressHUD.show()

        // Prepare URL
        guard let url = URL(string: "\(Urls.MOVIE_BY_CATEGORY_URL)?categoryId=\(categoryID)") else {
            SVProgressHUD.showError(withStatus: "Invalid URL")
            return
        }

        // Prepare request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(Storage.sharedInstance.accessToken)", forHTTPHeaderField: "Authorization")

        // Perform the data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()

                // Handle error
                if let error = error {
                    SVProgressHUD.showError(withStatus: "Connection Error: \(error.localizedDescription)")
                    return
                }

                // Handle response and status code
                guard let httpResponse = response as? HTTPURLResponse else {
                    SVProgressHUD.showError(withStatus: "Invalid response")
                    return
                }

                guard let data = data else {
                    SVProgressHUD.showError(withStatus: "No data received")
                    return
                }

                let resultString = String(data: data, encoding: .utf8) ?? "Unable to decode data"
                print(resultString)

                // Check if the status code is 200 (OK)
                if httpResponse.statusCode == 200 {
                    do {
                        // Parse JSON
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(CategoryMoviesResponse.self, from: data)
                        
                        if let content = response.content {
                            self.movies = content
                            self.tableView.reloadData()
                        } else {
                            SVProgressHUD.showError(withStatus: "Failed to parse JSON content")
                        }
                    } catch {
                        SVProgressHUD.showError(withStatus: "JSON Parsing Error: \(error.localizedDescription)")
                    }
                } else {
                    var errorString = "CONNECTION_ERROR".localized()
                    errorString += " \(httpResponse.statusCode)"
                    errorString += " \(resultString)"
                    SVProgressHUD.showError(withStatus: errorString)
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
        return movies.count
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
         cell.setData(movie: movies[indexPath.row])
         
         return cell
     }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 153.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieInfoVC = storyboard?.instantiateViewController(identifier: "MovieInfoViewController") as! MovieInfoViewController
        movieInfoVC.movie = movies[indexPath.row]
        navigationController?.show(movieInfoVC, sender: self)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
