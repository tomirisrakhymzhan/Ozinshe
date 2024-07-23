//
//  SignInViewController.swift
//  Ozinshe
//
//  Created by Томирис Рахымжан on 01/07/2024.
//

import UIKit
import SVProgressHUD

class SignInViewController: UIViewController, LanguageProtocol {

    
    
    @IBOutlet weak var greetingsLabel: UILabel!
    
    @IBOutlet weak var accountLoginLabel: UILabel!
    @IBOutlet weak var emailTextField: TextFieldWithPadding!
    @IBOutlet weak var passwordTextField: TextFieldWithPadding!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var noAccountLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var errorLabelHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var errorLabelEmailTextFieldConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var errorLabelToPasswordLabelConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        hideKeyboardWhenTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureViews()
    }
    
    func languageDidChange() {
        configureViews()
    }
    
    func configureViews(){
        greetingsLabel.text = "HELLO".localized()
        accountLoginLabel.text = "SIGN_IN".localized()
        passwordLabel.text = "PASSWORD".localized()
        loginButton.setTitle("LOG_IN".localized(), for: .normal)
        noAccountLabel.text = "NO_ACCOUNT".localized()
        signUpButton.setTitle("REGISTER".localized(), for: .normal)
        emailTextField.placeholder = "ENTER_EMAIL".localized()
        passwordTextField.placeholder = "ENTER_PASSWORD".localized()
        hideError()
    }
    
    func configureTextFields(){
        emailTextField.layer.cornerRadius = 12.0
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        passwordTextField.layer.cornerRadius = 12.0
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        loginButton.layer.cornerRadius = 12.0
        
    }
    
    func hideKeyboardWhenTapped(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
    @IBAction func textFieldEditingDidEnd(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1.00).cgColor
    }
    
    
    @IBAction func textFieldEditingDidBegin(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.00).cgColor
        hideError()
    }
    
    
    @IBAction func showPasswordButton(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        let signUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        
        signUpVC.modalPresentationStyle = .fullScreen
        
        navigationController?.show(signUpVC, sender: self)
    }
    
    
    @IBAction func signIn(_ sender: Any) {
        hideError()
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            SVProgressHUD.showError(withStatus: "Please enter your email and password.")
            return
        }

        if !isValidEmail(email) {
            showError("INVALID_EMAIL".localized())
            return
        }
        
        SVProgressHUD.show()

        // Define the URL
        guard let url = URL(string: Urls.SIGN_IN_URL) else {
            SVProgressHUD.showError(withStatus: "Invalid URL.")
            return
        }

        // Define the parameters
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]

        // Create the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Convert parameters to JSON data
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
        } catch {
            SVProgressHUD.showError(withStatus: "Failed to encode parameters.")
            return
        }

        // Perform the network request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }

            // Check for errors
            if let error = error {
                DispatchQueue.main.async {
                    SVProgressHUD.showError(withStatus: "Error: \(error.localizedDescription)")
                }
                return
            }

            // Check the response and status code
            if let httpResponse = response as? HTTPURLResponse {
                var resultString = ""
                if let data = data {
                    resultString = String(data: data, encoding: .utf8) ?? ""
                    print(resultString)
                }

                if httpResponse.statusCode == 200 {
                    // Parse JSON data
                    do {
                        if let jsonData = data {
                            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
                            if let token = json?["accessToken"] as? String {
                                Storage.sharedInstance.accessToken = token
                                UserDefaults.standard.set(token, forKey: "accessToken")
                                DispatchQueue.main.async {
                                    self.startApp()
                                }
                            } else {
                                DispatchQueue.main.async {
                                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                                }
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            SVProgressHUD.showError(withStatus: "Failed to parse JSON response.")
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        var errorString = "CONNECTION_ERROR".localized()
                        errorString += " \(httpResponse.statusCode)"
                        errorString += " \(resultString)"
                        SVProgressHUD.showError(withStatus: "\(errorString)")
                    }
                }
            }
        }

        task.resume()
    }
    
    func startApp(){
        let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabViewController
        
        tabBarVC.modalPresentationStyle = .fullScreen
        self.present(tabBarVC, animated: true )
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        errorLabelHeightConstraint.constant = 22
        errorLabelEmailTextFieldConstraint.constant = 16
        errorLabelToPasswordLabelConstraint.constant = 16
        emailTextField.layer.borderColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.0).cgColor
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    private func hideError() {
        errorLabel.text = nil
        errorLabel.isHidden = true
        errorLabelHeightConstraint.constant = 0
        errorLabelEmailTextFieldConstraint.constant = 0
        errorLabelToPasswordLabelConstraint.constant = 16
        emailTextField.layer.borderColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1.00).cgColor
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

}
