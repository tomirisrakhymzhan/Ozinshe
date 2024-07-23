//
//  ProfileViewController.swift
//  Ozinshe
//
//  Created by Томирис Рахымжан on 10/06/2024.
//

import UIKit
import Localize_Swift
import SVProgressHUD

class ProfileViewController: UIViewController , LanguageProtocol{

    
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
        notificationsSwitch.isOn = false
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureLabels()
        loadUserData()
    }

    @IBAction func languagePressed(_ sender: Any) {
        
        let languageVC = storyboard?.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
        
        languageVC.modalPresentationStyle = .overFullScreen
        languageVC.delegate = self
            
        present(languageVC, animated: true)
    }
    
    func languageDidChange() {
        configureLabels()
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
    
    @IBAction func darkModeChange(_ sender: Any) {
        if darkModeSwitch.isOn {
            darkModeSwitch.window?.overrideUserInterfaceStyle = .dark
        }else if !darkModeSwitch.isOn {
            darkModeSwitch.window?.overrideUserInterfaceStyle = .light
        }
    }
    
    @IBAction func notificationsValueChanged(_ sender: Any) {
        if notificationsSwitch.isOn {
            let alert = UIAlertController(title: "ALERT".localized(), message: "NOTIFICATIONS_ON".localized(), preferredStyle: .alert)
            self.present(alert, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                alert.dismiss(animated: true, completion: nil)
            }
        }else if !notificationsSwitch.isOn{
            let alert = UIAlertController(title: "ALERT".localized(), message: "NOTIFICATIONS_OFF".localized(), preferredStyle: .alert)
            self.present(alert, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func loadUserData(){
        guard let url = URL(string: Urls.GET_PROFILE) else {
            print("Could not get url: \(Urls.GET_PROFILE)")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(Storage.sharedInstance.accessToken)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            self.handleResponseData(data: data)
        }
        task.resume()
    }
    func handleResponseData(data: Data){
        do {
            let person = try JSONDecoder().decode(Person.self, from: data)
            print("Decoded JSON to Swift object: \(person)")
            DispatchQueue.main.async {
                self.emailLabel.text = person.user?.email ?? "no email available"
            }
        } catch {
            print("Failed to decode JSON: \(error)")
        }
    }
    

    @IBAction func logoutTapped(_ sender: Any) {
        let logoutVC = storyboard?.instantiateViewController(withIdentifier: "LogoutViewController") as! LogoutViewController
        logoutVC.modalPresentationStyle = .overFullScreen
        present(logoutVC, animated: true)
    }
}
