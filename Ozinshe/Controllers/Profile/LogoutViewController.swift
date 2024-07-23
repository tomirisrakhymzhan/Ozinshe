//
//  LogoutViewController.swift
//  Ozinshe
//
//  Created by Томирис Рахымжан on 22/07/2024.
//

import UIKit

class LogoutViewController: UIViewController, UIGestureRecognizerDelegate, LanguageProtocol {

    
    @IBOutlet weak var logoutLabel: UILabel!
    
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var yesButton: UIButton!
    
    
    @IBOutlet weak var noButton: UIButton!
    
    
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayers()
        configureViews()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureViews()
    }
    
    func languageDidChange() {
        configureViews()
    }

    
    func configureLayers() {
        
        yesButton.layer.cornerRadius = 12
        
        backgroundView.layer.cornerRadius = 32
        backgroundView.clipsToBounds = true
        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }
    func configureViews() {
        logoutLabel.text = "EXIT".localized()
        yesButton.setTitle("YES_BUTTON".localized(), for: .normal)
        noButton.setTitle("NO_BUTTON".localized(), for: .normal)
        subTitleLabel.text = "CONFIRMATION".localized()
    }
    
    @objc func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: backgroundView))! {
            return false
        }
        return true
    }
    
    @IBAction func yesButtonTapped(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        
        if let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInNavigationController") as? UINavigationController {
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate, let window = sceneDelegate.window {
                window.rootViewController = rootVC
                window.makeKeyAndVisible()
            }
        } else {
            print("Unable to instantiate view controller with identifier 'SignInNavigationController'")
        }

    }
    
    
    @IBAction func noButtonTapped(_ sender: Any) {
        dismissView()
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
