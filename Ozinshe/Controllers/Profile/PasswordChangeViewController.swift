//
//  PasswordChangeViewController.swift
//  Ozinshe
//
//  Created by Томирис Рахымжан on 13/06/2024.
//

import UIKit
import SVProgressHUD

class PasswordChangeViewController: UIViewController {

    @IBOutlet weak var firstPasswordTextField: UITextField!
    @IBOutlet weak var secondPasswordTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var show1Button: UIButton!
    @IBOutlet weak var show2Button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.layer.cornerRadius = 12
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideKeyboardWhenTapped()

    }
    
    
    @IBAction func show1Pressed(_ sender: Any) {
        firstPasswordTextField.isSecureTextEntry = !firstPasswordTextField.isSecureTextEntry

    }
    
    @IBAction func show2Pressed(_ sender: Any) {
        secondPasswordTextField.isSecureTextEntry = !secondPasswordTextField.isSecureTextEntry
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if firstPasswordTextField.text! == secondPasswordTextField.text!{
            
            let password = firstPasswordTextField.text!
            
            let parameters = [
                "password":password
            ]
            guard let jsonParameters = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                print("Error serializing parameters to JSON")
                return
            }
            guard let url = URL(string: Urls.CHANGE_PASSWORD) else {
                print("Could not get url: \(Urls.CHANGE_PASSWORD)")
                return
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "PUT"
            urlRequest.setValue("Bearer \(Storage.sharedInstance.accessToken)", forHTTPHeaderField: "Authorization")
            urlRequest.httpBody = jsonParameters
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
                self.handleChangePasswordResponseData(data: data)
            }
            task.resume()
            
            
        }
        else{
            print("passwords must be the same")
        }
    }
    func handleChangePasswordResponseData(data: Data){
        print(data.description)
        do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let dictionary = json as? [String: Any] {
                    print("JSON Dictionary: \(dictionary)")
                } else if let array = json as? [Any] {
                    print("JSON Array: \(array)")
                } else {
                    print("Unknown JSON format")
                }
            } catch {
                print("Failed to parse JSON: \(error)")
            }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func hideKeyboardWhenTapped(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
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
