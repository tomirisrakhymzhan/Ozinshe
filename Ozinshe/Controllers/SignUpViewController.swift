//
//  SignUpViewController.swift
//  Ozinshe
//
//  Created by Томирис Рахымжан on 01/07/2024.
//

import UIKit
import SVProgressHUD

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var fillDetailsLabel: UILabel!
    @IBOutlet weak var emailTextField: TextFieldWithPadding!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordRepeatLabel: UILabel!
    @IBOutlet weak var passwordTextField1: TextFieldWithPadding!
    @IBOutlet weak var passwordTextField2: TextFieldWithPadding!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var alreadyHaveAccountLabel: UILabel!
  
    @IBOutlet weak var signInButton: UIButton!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var errorLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var errorLabelToPasswordTextField2Constraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var errorLabelToRegisterButtonConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextfields()
        hideKeyboardWhenTapped()

    }
    
    func configureTextfields(){
        emailTextField.layer.cornerRadius = 12.0
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        passwordTextField1.textContentType = .oneTimeCode
        passwordTextField1.layer.cornerRadius = 12.0
        passwordTextField1.layer.borderWidth = 1.0
        passwordTextField1.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        passwordTextField2.textContentType = .oneTimeCode
        passwordTextField2.layer.cornerRadius = 12.0
        passwordTextField2.layer.borderWidth = 1.0
        passwordTextField2.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        registerButton.layer.cornerRadius = 12.0
        registerButton.titleLabel?.adjustsFontSizeToFitWidth = true
        registerButton.titleLabel?.minimumScaleFactor = 0.5
        
        
    }
    
    func hideKeyboardWhenTapped(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        configureViews()
        
    }
    
    func languageDidChange() {
        configureViews()
    }
    
    func configureViews(){
        registerLabel.text = "REGISTER".localized()
        fillDetailsLabel.text = "FILL_IN".localized()
        emailTextField.placeholder = "ENTER_EMAIL".localized()
        passwordLabel.text = "PASSWORD".localized()
        passwordRepeatLabel.text = "REPEAT_PASSWORD".localized()
        passwordTextField1.placeholder = "ENTER_PASSWORD".localized()
        passwordTextField2.placeholder = "REPEAT_PASSWORD".localized()
        registerButton.setTitle("REGISTER".localized(), for: .normal)
        alreadyHaveAccountLabel.text = "HAVE_ACCOUNT".localized()
        signInButton.setTitle("LOG_IN".localized(), for: .normal)
        hideError()

    }
    
    @IBAction func showPasswordPressed(_ sender: Any) {
        passwordTextField1.isSecureTextEntry.toggle()
    }
    
    
    @IBAction func showPasswordRepeatPresed(_ sender: Any) {
        passwordTextField2.isSecureTextEntry.toggle()
    }
    
    @IBAction func textFieldEditingDidBegin(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.00).cgColor
        hideError()
    }
    
    
    @IBAction func textFieldEditingDidEnd(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1.00).cgColor
        hideError()

    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        hideError()
        
        guard let email = emailTextField.text, !email.isEmpty,
              let password1 = passwordTextField1.text, !password1.isEmpty,
              let password2 = passwordTextField2.text, !password2.isEmpty else {
            showError("FILL_ALL_FIELDS".localized())
            return
        }
        
        guard isValidEmail(email) else {
            showError("INVALID_EMAIL".localized())
            return
        }
        
        guard isValidPassword(password1) else {
            showError("WEAK_PASSWORD".localized())
            return
        }
        
        if password1 != password2 {
            showError("WRONG_PASSWORD".localized())
            return
        }
        
        SVProgressHUD.show()
        
        let parameters = [
            "email": email,
            "password": password1
        ]
        
        guard let url = URL(string: Urls.SIGN_UP_URL) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            handleError(error, message: "JSON encoding failed:")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let error = error {
                    self.handleError(error, message: "Request error:")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.showError("Invalid response")
                    return
                }
                
                guard let data = data else {
                    self.showError("No data received")
                    return
                }
                
                let resultString = String(data: data, encoding: .utf8) ?? ""
                print("Raw response: \(resultString)")
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("Parsed JSON: \(json)")
                        
                        if httpResponse.statusCode == 200 {
                            if let token = json["accessToken"] as? String {
                                Storage.sharedInstance.accessToken = token
                                UserDefaults.standard.set(token, forKey: "accessToken")
                                self.startApp()
                            } else {
                                self.showError("CONNECTION_ERROR".localized())
                            }
                        } else {
                            var errorString = "CONNECTION_ERROR".localized()
                            errorString += " \(httpResponse.statusCode)"
                            errorString += " \(resultString)"
                            self.showError(errorString)
                        }
                    } else {
                        self.showError("Failed to parse JSON")
                    }
                } catch {
                    self.handleError(error, message: "JSON parsing failed:")
                }
            }
        }
        
        task.resume()
    }

    @IBAction func signInPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
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

    func isValidPassword(_ password: String) -> Bool {
        // Password must be at least 6 characters long
        return password.count >= 6
    }
    
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        errorLabelHeightConstraint.constant = 22
        errorLabelToPasswordTextField2Constraint.constant = 32
        errorLabelToRegisterButtonConstraint.constant = 32
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    private func hideError() {
        errorLabel.text = nil
        errorLabel.isHidden = true
        errorLabelHeightConstraint.constant = 0
        errorLabelToPasswordTextField2Constraint.constant = 0
        errorLabelToRegisterButtonConstraint.constant = 40
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    private func handleError(_ error: Error, message: String) {
        SVProgressHUD.showError(withStatus: "\(message) \(error.localizedDescription)")
        showError("\(message) \(error.localizedDescription)")
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
