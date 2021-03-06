//
//  LoginViewController.swift
//  Document Cryptor
//
//  Created by Sugirdha on 1/12/20.


import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        if passwordTextField.text != "" && usernameTextField.text != "" {
            let username = "user1"
            let password = "pw12345"
            
            if (password.count > 0) {
                if (usernameTextField.text == username && passwordTextField.text == password) {
                    performSegue(withIdentifier: "loginToBrowser", sender: self)
                } else {
                    let alert = UIAlertController(title: "Login Error", message: "Invalid Username/Password combination", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "Try again", style: .cancel)
                    alert.addAction(cancel)
                    present(alert, animated: true, completion: nil)
                }
            }
        } else {
            let alert = UIAlertController(title: "Input Error", message: "Username / Password cannot be empty", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Try again", style: .cancel)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DocumentBrowserViewController
        destinationVC.loginPassword = passwordTextField.text!
    }
    
}
