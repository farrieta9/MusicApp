//
//  RegisterView.swift
//  SongBar
//
//  Created by Francisco Arrieta on 9/8/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit

class RegisterView: UIView {
    
    let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    let usernameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Username"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.autocorrectionType = .No
        textfield.keyboardType = .Default
        textfield.autocapitalizationType = .None
        return textfield
    }()
    
    let emailTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Email"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.autocorrectionType = .No
        textfield.keyboardType = .EmailAddress
        textfield.autocapitalizationType = .None
        return textfield
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(220, green: 220, blue: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(220, green: 220, blue: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Password"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.secureTextEntry = true
        textfield.keyboardType = .Default
        textfield.autocorrectionType = .No
        textfield.autocapitalizationType = .None
        return textfield
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(inputContainerView)
        addSubview(registerButton)
        
        // need x, y, width, height
        inputContainerView.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        inputContainerView.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        inputContainerView.widthAnchor.constraintEqualToAnchor(widthAnchor, constant: -24).active = true
        inputContainerView.heightAnchor.constraintEqualToConstant(150).active = true
        
        inputContainerView.addSubview(usernameTextField)
        inputContainerView.addSubview(nameSeparatorView)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailSeparatorView)
        inputContainerView.addSubview(passwordTextField)
        
        usernameTextField.centerXAnchor.constraintEqualToAnchor(inputContainerView.centerXAnchor).active = true
        usernameTextField.topAnchor.constraintEqualToAnchor(inputContainerView.topAnchor).active = true
        usernameTextField.widthAnchor.constraintEqualToAnchor(inputContainerView.widthAnchor, constant: -24).active = true
        usernameTextField.heightAnchor.constraintEqualToAnchor(inputContainerView.heightAnchor, multiplier: 1/3).active = true
        
        nameSeparatorView.centerXAnchor.constraintEqualToAnchor(inputContainerView.centerXAnchor).active = true
        nameSeparatorView.topAnchor.constraintEqualToAnchor(usernameTextField.bottomAnchor).active = true
        nameSeparatorView.widthAnchor.constraintEqualToAnchor(inputContainerView.widthAnchor).active = true
        nameSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
        
        emailTextField.centerXAnchor.constraintEqualToAnchor(inputContainerView.centerXAnchor).active = true
        emailTextField.topAnchor.constraintEqualToAnchor(nameSeparatorView.bottomAnchor).active = true
        emailTextField.widthAnchor.constraintEqualToAnchor(inputContainerView.widthAnchor, constant: -24).active = true
        emailTextField.heightAnchor.constraintEqualToAnchor(inputContainerView.heightAnchor, multiplier: 1/3).active = true
        
        emailSeparatorView.centerXAnchor.constraintEqualToAnchor(inputContainerView.centerXAnchor).active = true
        emailSeparatorView.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
        emailSeparatorView.widthAnchor.constraintEqualToAnchor(inputContainerView.widthAnchor).active = true
        emailSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
        
        passwordTextField.centerXAnchor.constraintEqualToAnchor(inputContainerView.centerXAnchor).active = true
        passwordTextField.topAnchor.constraintEqualToAnchor(emailSeparatorView.bottomAnchor).active = true
        passwordTextField.widthAnchor.constraintEqualToAnchor(inputContainerView.widthAnchor, constant: -24).active = true
        passwordTextField.heightAnchor.constraintEqualToAnchor(inputContainerView.heightAnchor, multiplier: 1/3).active = true
        
        registerButton.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        registerButton.topAnchor.constraintEqualToAnchor(inputContainerView.bottomAnchor, constant: 8).active = true
        registerButton.widthAnchor.constraintEqualToAnchor(inputContainerView.widthAnchor).active = true
        registerButton.heightAnchor.constraintEqualToConstant(50).active = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}