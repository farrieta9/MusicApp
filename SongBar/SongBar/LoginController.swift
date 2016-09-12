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
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor() // Makes the back button white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        setUpView()
    }
    
    func handleAutoSignIn() {
        if FIRAuth.auth()?.currentUser?.uid != nil {
            performSelector(#selector(self.showAppTabBarController), withObject: nil, afterDelay: 0)
        }
    }
    
    func setUpView() {
        view.addSubview(loginView)
        
        // need x, y, width, height
        loginView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        loginView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        loginView.heightAnchor.constraintEqualToAnchor(view.heightAnchor).active = true
        
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
        loginView.loginButton.addTarget(self, action: #selector(handleLogin), forControlEvents: .TouchUpInside)
        loginView.signUpButton.addTarget(self, action: #selector(self.handleRegisterButton), forControlEvents: .TouchUpInside)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func handleLogin() {
        guard let email = loginView.emailTextField.text, password = loginView.passwordTextField.text else {
            return
        }
        
        if validateForm() == false {
            return
        }
        
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
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
        self.presentViewController(app, animated: true, completion: nil)
    }
    
    func validateForm() -> Bool {
        guard let email = loginView.emailTextField.text, password = loginView.passwordTextField.text else {
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
    
    private func displayAlert(message: String) {
        let alertController = UIAlertController(title: "Invalid", message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
}

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}