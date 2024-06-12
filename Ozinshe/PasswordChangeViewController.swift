//
//  PasswordChangeViewController.swift
//  Ozinshe
//
//  Created by Томирис Рахымжан on 13/06/2024.
//

import UIKit

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
