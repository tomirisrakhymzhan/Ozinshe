//
//  PersonalInfoViewController.swift
//  Ozinshe
//
//  Created by Томирис Рахымжан on 13/06/2024.
//

import UIKit
import SVProgressHUD

class PersonalInfoViewController: UIViewController {

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.layer.cornerRadius = 12
        hideKeyboardWhenTapped()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        loadUserData()
    }
    @IBAction func saveDataPressed(_ sender: Any) {
        saveData()
        loadUserData()

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
                self.nameTextField.text = person.name ?? "no data"
                self.emailTextField.text = person.user?.email ?? "no data"
                self.phoneTextField.text = person.phoneNumber ?? "no data"
                self.dateOfBirthTextField.text = person.birthDate ?? "no data"
            }
        } catch {
            print("Failed to decode JSON: \(error)")
        }
    }
    
    func saveData(){
        let name = nameTextField.text!
        let email = emailTextField.text!
        let phone = phoneTextField.text!
        
        let language = ""
        let id: Int = 0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateOfBirthTextField.text ?? "") ?? Date()
        let birthDate = dateFormatter.string(from: date)
                
        guard let url = URL(string: Urls.UPDATE_PROFILE) else {
            print("Could not get url: \(Urls.UPDATE_PROFILE)")
            return
        }
        let parameters: [String: Any] = [
            "birthDate": birthDate,
            "id": id,
            "language": language,
            "name": name,
            "phoneNumber": phone,
            "user": [
                "email": email
            ]
        ]
        guard let jsonParams = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Error serializing parameters to JSON")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(Storage.sharedInstance.accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = jsonParams
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
            self.handleUpdateProfileResponseData(data: data)
        }
        task.resume()
        
    }
    func handleUpdateProfileResponseData(data: Data){
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
