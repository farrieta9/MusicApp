//
//  LoginController.swift
//  SongBar
//
//  Created by Francisco Arrieta on 9/8/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    let loginView: LoginView = {
        let view =  LoginView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.handleAutoSignIn()
        view.backgroundColor = UIColor.rgb(100, green: 100, blue: 100)
        
        self.navigationItem.title = "Login"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white // Makes the back button white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        setUpView()
    }
    
    func handleAutoSignIn() {
        if FIRAuth.auth()?.currentUser?.uid != nil {
            perform(#selector(self.showAppTabBarController), with: nil, afterDelay: 0)
        }
    }
    
    func setUpView() {
        view.addSubview(loginView)
        
        // need x, y, width, height
        loginView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        loginView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
        loginView.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        loginView.signUpButton.addTarget(self, action: #selector(self.handleRegisterButton), for: .touchUpInside)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func handleLogin() {
        guard let email = loginView.emailTextField.text, let password = loginView.passwordTextField.text else {
            return
        }
        
        if validateForm() == false {
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error)
                self.displayAlert("Error with email or password")
                print(error?.userInfo)
                return
            } else {
                self.showAppTabBarController()
            }
        })
    }
    
    func showAppTabBarController() {
        let app = AppTabBarController()
        self.present(app, animated: true, completion: nil)
    }
    
    func validateForm() -> Bool {
        guard let email = loginView.emailTextField.text, let password = loginView.passwordTextField.text else {
            return false
        }
        
        if email.isEmpty || password.isEmpty {
            displayAlert("All entries must be filled")
            return false
        }
        
        if password.characters.count < 6 {
            displayAlert("Password must be 6 characters or more")
            return false
        }
        
        return true
    }
    
    func handleRegisterButton() {
        let registerController = RegisterController()
        navigationController?.pushViewController(registerController, animated: true)
    }
    
    fileprivate func displayAlert(_ message: String) {
        let alertController = UIAlertController(title: "Invalid", message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
