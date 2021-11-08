//
//  AuthManagerVM+ Service.swift
//  W D L C Rathnasiri-COBSCComp201P-017
//
//  Created by Sahan Ravindu on 2021-11-08.
//

import Foundation

extension AuthManagerVM {
    func registerUser(user: User, completion: @escaping CompletionApiHandler) {
        guard let uid = auth.currentUser?.uid else {return}
        
        let dbReference = self.ref.child("user/profile/\(uid)")
        dbReference.setValue(user.nsDictionary) { [weak self] error, ref in
            if error != nil {
                self?.response = ResponseData(title: "Error", message: error?.localizedDescription ?? "" , error:  .error("Please enter an email and a password"))
                completion(false)
            } else {
                completion(true)
            }
        }
       
    }
}
