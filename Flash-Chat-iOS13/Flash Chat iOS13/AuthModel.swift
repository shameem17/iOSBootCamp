//
//  AuthModel.swift
//  Flash Chat iOS13
//
//  Created by Shameem on 8/10/24.
//  Copyright © 2024 Angela Yu. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@objc protocol AuthDelegate{
    @objc optional func emailError(placeholder: String)
    @objc optional func passwordError(placeholder: String)
    func authError(error: Error)
    @objc optional func registrationSuccess(authResult: Any?)
    @objc optional func loginSuccess(authResult: Any?)
    @objc optional func logoutSuccess()
}

enum AuthType{
    case login
    case register
}

struct AuthManager{
    func logout() {
        do{
            try Auth.auth().signOut()
            self.delegate?.logoutSuccess?()
        }catch(let error){
            self.delegate?.authError(error: error)
        }
    }
    
    var delegate: AuthDelegate?
    
    func authenticationHandler(email: String,
                               password: String,
                               authType: AuthType){
        let isVaildEamil = self.isEamilVaild(email: email)
        let isVaildPassword = self.isPasswordValid(password: password)
        if !isVaildEamil{
            self.delegate?.emailError?(placeholder: Constants.invalidEmail)
        }
        if !isVaildPassword{
            self.delegate?.passwordError?(placeholder: Constants.invalidPassword)
        }
        if isVaildEamil && isVaildPassword{
            if authType == .register{
                self.createNewUser(email: email,
                                   password: password)
            }else{
                self.login(email: email,
                           password: password)
            }
        }
        
    }
    
    private func isEamilVaild(email: String) -> Bool{
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPred.evaluate(with: email)
    }
    private func isPasswordValid(password: String) -> Bool{
        return password.count >= 6
    }
    
    private func createNewUser(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password){ authResult, error in
            // ...
            if error == nil{
                print("auth result =\(authResult?.user.uid)")
                self.delegate?.registrationSuccess?(authResult: authResult)
               
            }else{
                self.delegate?.authError(error: error!)
                print("error auth=\(error)")
            }
        }
    }
    
    private func login(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password){ authResult, error in
            // ...
            if error == nil{
                print("auth result =\(authResult?.user.uid)")
                self.delegate?.loginSuccess?(authResult: authResult)
               
            }else{
                self.delegate?.authError(error: error!)
                print("error auth=\(error)")
            }
        }
    }
    
}
