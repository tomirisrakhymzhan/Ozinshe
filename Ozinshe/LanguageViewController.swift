//
//  LanguageViewController.swift
//  Ozinshe
//
//  Created by Томирис Рахымжан on 10/06/2024.
//

import UIKit
import Localize_Swift
protocol LanguageProtocol{
    func languageDidChange()
}
class LanguageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    
    var delegate: LanguageProtocol?

        var languageArray = [["English", "en"], ["Қазақша", "kk"], ["Русский", "ru"]]

        
        override func viewDidLoad() {
            super.viewDidLoad()

            // Do any additional setup after loading the view.
            
            tableView.dataSource = self
            tableView.delegate = self
        }
        

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return languageArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath)
            
            let label = cell.viewWithTag(1000) as! UILabel
            label.text = languageArray[indexPath.row][0]
            
            let checkImageView = cell.viewWithTag(1001) as! UIImageView
            
            if Localize.currentLanguage() == languageArray[indexPath.row][1]{
                checkImageView.image = UIImage(named: "Check")
            }else{
                checkImageView.image = nil
            }
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 65.0
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            Localize.setCurrentLanguage(languageArray[indexPath.row][1])
            delegate?.languageDidChange()
            dismiss(animated: true)
            
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
