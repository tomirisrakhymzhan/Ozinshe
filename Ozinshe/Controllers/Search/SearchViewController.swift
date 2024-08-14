//
//  SearchViewController.swift
//  Ozinshe
//
//  Created by Томирис Рахымжан on 26/07/2024.
//

import UIKit
import SVProgressHUD

class SearchViewController: UIViewController, LanguageProtocol, UICollectionViewDelegate, UITableViewDelegate {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var searchNavigationItem: UINavigationItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var tableViewToCollectionViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewToCategoriesLabelConstraint: NSLayoutConstraint!
    
    var categories: [Category] = []
    var movies:[Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        hideKeyboardWhenTapped()
        downloadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        languageDidChange()
        
    }
    
    func languageDidChange() {
        searchNavigationItem.title = "SEARCH".localized()
        searchTextField.placeholder = "TO_SEARCH".localized()
        if searchTextField.text!.isEmpty{
            categoriesLabel.text = "CATEGORIES".localized()
        }
        else{
            categoriesLabel.text = "SEARCH_RESULTS".localized()
        }
        
    }
    
    class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

        override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            let attributes = super.layoutAttributesForElements(in: rect)

            var leftMargin = sectionInset.left
            var maxY: CGFloat = -1.0
            attributes?.forEach { layoutAttribute in
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }

                layoutAttribute.frame.origin.x = leftMargin

                leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
                maxY = max(layoutAttribute.frame.maxY , maxY)
            }

            return attributes
        }
    }
    
    func configureViews(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16.0, left: 24.0, bottom: 16.0, right: 24.0)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 16
        layout.estimatedItemSize.width = 100
        collectionView.collectionViewLayout = layout
        
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: searchTextField.frame.height))
        searchTextField.leftViewMode = .always
        searchTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: searchTextField.frame.height))
        searchTextField.rightViewMode = .always
        searchTextField.layer.cornerRadius = 12.0
        searchTextField.layer.borderWidth = 1.0
        searchTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        tableView.dataSource = self
        tableView.delegate = self
//
        let MovieCelNib = UINib(nibName: "MovieCell", bundle: nil)
        tableView.register(MovieCelNib, forCellReuseIdentifier: "MovieCell")
    }
    
    func hideKeyboardWhenTapped(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        searchTextField.text = ""
        downloadSearchMovies()
        
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        downloadSearchMovies()
    }
    
    
    @IBAction func textEditingDidBegin(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.00).cgColor
    }
    
    @IBAction func textEditingDidEnd(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1.00).cgColor
    }
    
    @IBAction func textEditingChanged(_ sender: Any) {
        downloadSearchMovies()
    }
    
    func downloadCategories() {
        SVProgressHUD.show()
        
        // Prepare the URL and request
        guard let url = URL(string: Urls.CATEGORY_URL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(Storage.sharedInstance.accessToken)", forHTTPHeaderField: "Authorization")
        
        // Create a data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
            
            // Print the raw JSON string for debugging
            guard let jsonString = String(data: data, encoding: .utf8) else {
                return
            }
            print("Received JSON: \(jsonString)")
                    
            
            // Check for HTTP errors
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    let categoriesResponse = try decoder.decode(Categories.self, from: data)
                    
                    // Update the UI on the main thread
                    DispatchQueue.main.async {
                        self.categories = categoriesResponse
                        self.collectionView.reloadData()
                    }
                } catch {
                    print("Decoding error: \(error)")
                    DispatchQueue.main.async {
                        SVProgressHUD.showError(withStatus: "JSON_PARSING_ERROR".localized())
                    }
                }
            } else {
                var errorString = "CONNECTION_ERROR".localized()
                if let httpResponse = response as? HTTPURLResponse {
                    errorString += " \(httpResponse.statusCode)"
                }
                DispatchQueue.main.async {
                    SVProgressHUD.showError(withStatus: errorString)
                }
            }
        }
        
        // Start the task
        task.resume()
    }
    
    func downloadSearchMovies() {
        print("downloadSearchMovies")
        guard let searchText = searchTextField.text else { return }

        if searchText.isEmpty {
            categoriesLabel.text = "CATEGORIES".localized()
            collectionView.isHidden = false
            tableView.isHidden = true
            clearButton.isHidden = true
            tableViewToCategoriesLabelConstraint.priority = .defaultLow
            tableViewToCollectionViewConstraint.priority = .defaultHigh
            movies.removeAll()
            tableView.reloadData()
            return
        } else {
            categoriesLabel.text = "SEARCH_RESULTS".localized()
            clearButton.isHidden = false
            collectionView.isHidden = true
            tableView.isHidden = false
            tableViewToCategoriesLabelConstraint.priority = .defaultHigh
            tableViewToCollectionViewConstraint.priority = .defaultLow
        }
        
        SVProgressHUD.show()
        
        // Create URLComponents to add query parameters
        var urlComponents = URLComponents(string: Urls.SEARCH_MOVIE_URL)!
        urlComponents.queryItems = [URLQueryItem(name: "search", value: searchText)]
        
        // Create URLRequest and set headers
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(Storage.sharedInstance.accessToken)", forHTTPHeaderField: "Authorization")
        
        // Create data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
            
            // Check for HTTP errors
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    let movies = try decoder.decode(Movies.self, from: data)
                    print(movies)
                    // Update the UI on the main thread
                    DispatchQueue.main.async {
                        self.movies = movies
                        self.tableView.reloadData()
                    }
                } catch {
                    DispatchQueue.main.async {
                        SVProgressHUD.showError(withStatus: "JSON_PARSING_ERROR".localized())
                    }
                }
            } else {
                var errorString = "CONNECTION_ERROR".localized()
                if let httpResponse = response as? HTTPURLResponse {
                    errorString += " \(httpResponse.statusCode)"
                }
                //errorString += " \(resultString)"
                DispatchQueue.main.async {
                    SVProgressHUD.showError(withStatus: errorString)
                }
            }
        }
        
        // Start the task
        task.resume()
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

extension SearchViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let label = cell.viewWithTag(1001) as! UILabel
        label.text = categories[indexPath.row].name
        
        let backgroundView = cell.viewWithTag(1000)!
        backgroundView.layer.cornerRadius = 8.0
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let categoryTableViewController = storyboard?.instantiateViewController(withIdentifier: "CategoryTableViewController") as! CategoryTableViewController
        categoryTableViewController.categoryID = categories[indexPath.row].id ?? 0
        categoryTableViewController.categoryName = categories[indexPath.row].name ?? ""
       
        
        navigationController?.show(categoryTableViewController, sender: self)
    }
    
}

extension SearchViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
  
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 153
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        cell.setData(movie: movies[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieInfoVC = storyboard?.instantiateViewController(identifier: "MovieInfoViewController") as! MovieInfoViewController
        movieInfoVC.movie = movies[indexPath.row]
        navigationController?.show(movieInfoVC, sender: self)
    }
    
}
