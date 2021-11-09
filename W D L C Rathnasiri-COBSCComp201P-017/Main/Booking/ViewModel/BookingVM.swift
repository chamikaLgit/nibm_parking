//
//  BookingVM.swift
//  W D L C Rathnasiri-COBSCComp201P-017
//
//  Created by Sahan Ravindu on 2021-11-09.
//

import Foundation
import Firebase

class BookingVM: ObservableObject {
    
    //MARK: Variable
    var ref = Database.database().reference()
    @Published var user: User?
    @Published var isLoading = false
    
    func getLoginProfile(completion: @escaping CompletionApiHandler) {
        let userID = Auth.auth().currentUser?.uid
        
        ref.child("user/profile/").child(userID!).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            
            self?.isLoading = false
            let userObj = snapshot.value as! [String: Any]
            self?.user = User(id: userObj["id"] as? String, nicNo: userObj["nicNo"] as? String, name: userObj["name"] as? String, email: userObj["email"] as? String, vehicleNo: userObj["vehicleNo"] as? String)
            completion(true)
        }) { (error) in
            print(error.localizedDescription)
            completion(true)
        }
                
    }
}
