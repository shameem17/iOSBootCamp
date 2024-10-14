//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    var authManager = AuthManager()
    override func viewDidLoad() {
        self.emailTextfield.delegate = self
        self.passwordTextfield.delegate = self
        self.emailTextfield.becomeFirstResponder()
        self.authManager.delegate = self
    }
}

// MARK: - TextField Delegate

extension RegisterViewController: UITextFieldDelegate{
    
    @IBAction func registerPressed(_ sender: UIButton) {
        let password = passwordTextfield.text ?? ""
        let email = emailTextfield.text ?? ""
        self.authManager.authenticationHandler(email: email,
                                               password: password,
                                               authType: .register)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
}

// MARK: - authDelegate

extension RegisterViewController: AuthDelegate{
    func emailError(placeholder: String) {
        DispatchQueue.main.async{[weak self] in
            self?.emailTextfield.text = ""
            self?.emailTextfield.placeholder = placeholder
        }
    }
    
    func passwordError(placeholder: String) {
        DispatchQueue.main.async{[weak self] in
            self?.passwordTextfield.text = ""
            self?.passwordTextfield.placeholder = placeholder
            
        }
    }
    
    func authError(error: any Error) {
        print("error in auth=\(error)")
    }
    
    func registrationSuccess(authResult: Any?) {
        self.performSegue(withIdentifier: Constants.regsiterSegue,
                          sender: self)
    }
}
