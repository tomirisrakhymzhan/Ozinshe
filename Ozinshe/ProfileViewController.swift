//
//  ProfileViewController.swift
//  Ozinshe
//
//  Created by Томирис Рахымжан on 10/06/2024.
//

import UIKit
import Localize_Swift
class ProfileViewController: UIViewController {

    
    @IBOutlet weak var navigationLabel: UINavigationItem!
    @IBOutlet weak var myProfileLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var personalDataButton: UIButton!
    @IBOutlet weak var editPersonalDataLabel: UILabel!
    @IBOutlet weak var passwordChangeButton: UIButton!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var languageSelectionLabel: UILabel!
    @IBOutlet weak var termsAndConditionsButton: UIButton!
    @IBOutlet weak var notificationsButton: UIButton!
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var darkModeButton: UIButton!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureLabels()
    }

    @IBAction func languagePressed(_ sender: Any) {
        
        let languageVC = storyboard?.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
        
        languageVC.modalPresentationStyle = .overFullScreen
            
        present(languageVC, animated: true)
    }
    
    func configureLabels(){
        if Localize.currentLanguage() == "en"{
            languageSelectionLabel.text = "English"
            navigationLabel.title = "Profile"
        }
        if Localize.currentLanguage() == "kk"{
            languageSelectionLabel.text = "Қазақша"
            navigationLabel.title = "Профиль"
        }
        if Localize.currentLanguage() == "ru"{
            languageSelectionLabel.text = "Русский"
            navigationLabel.title = "Профиль"
        }
        myProfileLabel.text = "MY_PROFILE".localized()
        personalDataButton.setTitle("PERSONAL_DATA".localized(), for: .normal)
        editPersonalDataLabel.text = "EDIT".localized()
        passwordChangeButton.setTitle("CHANGE_PASSWORD".localized(), for: .normal)
        termsAndConditionsButton.setTitle("TERM_&_CONDITIONS".localized(), for: .normal)
        notificationsButton.setTitle("NOTIFICATIONS".localized(), for: .normal)
        darkModeButton.setTitle("DARK_MODE".localized(), for: .normal)
        languageButton.setTitle("LANGUAGE".localized(), for: .normal)

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
