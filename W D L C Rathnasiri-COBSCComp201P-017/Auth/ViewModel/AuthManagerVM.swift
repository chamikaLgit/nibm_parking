//
//  AuthManagerVM.swift
//  Parking-Reservation
//
//  Created by Sahan Ravindu on 2021-11-01.
//

import Foundation
import FirebaseAuth
import Firebase
import SwiftUI

class AuthManagerVM: ObservableObject {
    
    //MARK: Variables
    let auth = Auth.auth()
    @Published var signedIn = false
    @Published var response: ResponseData?
    @Published var isLoading = false
//    var ref: DatabaseReference!
    var ref = Database.database().reference()
    var user: User?
    
    //Validation
    func validateForm(email: String, password: String)-> Bool {
        if email.isEmpty || password.isEmpty {
            
            self.response = ResponseData(title: "Error", message: "Please enter an email and a password", error:  .error("Please enter an email and a password"))
            return false
        } else if !isValidEmail(email) {
            self.response = ResponseData(title: "Error", message: "Please enter valid email", error:  .error("Please enter valid email"))
            return false
        }
        return true
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    func signIn(email: String, password: String, completion: @escaping CompletionApiHandler) {
        self.isLoading = true
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            self?.isLoading = false
            if error != nil {
                self?.response = ResponseData(title: "Error", message: error?.localizedDescription ?? "" , error:  .error(""))
                completion(false)
            } else {
                DispatchQueue.main.async {
                    //Success
                    self?.signedIn = true
                }
                completion(true)
            }
            
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping CompletionApiHandler) {
        self.isLoading = true
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            self?.isLoading = false
            if error != nil {
                self?.response = ResponseData(title: "Error", message: error?.localizedDescription ?? "" , error:  .error(""))
                completion(false)
            } else {
                DispatchQueue.main.async {
                    //Success
                    if let _user = self?.user {
                        let newUser = User(id: self?.auth.currentUser?.uid, nicNo: _user.nicNo, name: _user.name, email: _user.email, vehicleNo: _user.vehicleNo)
                        self?.registerUser(user: newUser, completion: { [weak self] status in
                            if status {
                                self?.signedIn = true
                                completion(true)
                            } else {
                                completion(false)
                            }
                        })
                    } else {
                        self?.response = ResponseData(title: "Error", message: "Please fill the data" , error:  .error(""))
                        completion(false)
                    }
                }
                
            }
            
            
        }
    }
    
    func resetPassword(email: String, completion: @escaping CompletionApiHandler) {
        self.isLoading = true
        auth.sendPasswordReset(withEmail: email) { [weak self] error in
            self?.isLoading = false
            
            if error != nil {
                self?.response = ResponseData(title: "Error", message: error?.localizedDescription ?? "" , error:  .error("Please enter an email and a password"))
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func signOut() {
        try? auth.signOut()
        self.signedIn = false
    }
}

