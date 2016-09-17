//
//  RegisterController.swift
//  SongBar
//
//  Created by Francisco Arrieta on 9/8/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//


import UIKit
import Firebase

class RegisterController: UIViewController {
    
    let registerView: RegisterView = {
        let view = RegisterView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        indicator.clipsToBounds = true
        indicator.color = UIColor.white
        indicator.layer.cornerRadius = 5
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(100, green: 100, blue: 100)
        
        setUpView()
    }
    
    func validateForm() -> Bool {
        guard let email = registerView.emailTextField.text, let password = registerView.passwordTextField.text, let username = registerView.usernameTextField.text else {
            return false
        }
        
        if email.isEmpty || password.isEmpty || username.isEmpty {
            displayAlert("All entries must be filled")
            return false
        }
        
        if password.characters.count < 6 {
            displayAlert("Password must be 6 characters or more")
            return false
        }
        
        return true
    }
    
    func handleSignUpButton() {
        
        guard let email = registerView.emailTextField.text, let password = registerView.passwordTextField.text?.lowercased(), let username = registerView.usernameTextField.text?.lowercased() else {
            return
        }
        
        if validateForm() == false {
            return
        }
        
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addSubview(indicator)
            window.addSubview(blackView)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            indicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            indicator.center = window.center
            indicator.startAnimating()
            
            UIView.animate(withDuration: 0.4, animations: { 
                self.blackView.alpha = 1
            }, completion: { (true) in
                self.createUserWithEmail(email, password: password, username: username)
            })
        }
    }
    
    fileprivate func createUserWithEmail(_ email: String, password: String, username: String) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error)
                self.indicator.stopAnimating()
                self.blackView.removeFromSuperview()
                self.displayAlert("Invalid email or password")
                return
            } else {
                
                guard let uid = user?.uid else {
                    return
                }
                
                // Successfully created user in firebase
                let values = ["username": username, "email": email]
                
                FIRDatabase.database().reference().child("users").child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                    self.indicator.stopAnimating()
                    self.blackView.removeFromSuperview()
                    if error != nil {
                        print(error)
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }
        })
    }
    
    fileprivate func setUpView() {
        view.addSubview(registerView)
        
        registerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        registerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        registerView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        registerView.emailTextField.delegate = self
        registerView.passwordTextField.delegate = self
        registerView.usernameTextField.delegate = self
        registerView.registerButton.addTarget(self, action: #selector(handleSignUpButton), for: .touchUpInside)
    }
    
    fileprivate func displayAlert(_ message: String) {
        let alertController = UIAlertController(title: "Invalid", message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension RegisterController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
