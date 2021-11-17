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
    @Published var response: ResponseData?
    @Published var slotList: [Slot] = []
    let mainVm = MainVM()
    
    func geSlotList(completion: @escaping CompletionApiHandler) {
        mainVm.getSlotList { status in
            
        }
    }
    
    func getLoginProfile(completion: @escaping CompletionApiHandler) {
        let userID = Auth.auth().currentUser?.uid
        isLoading.toggle()
        ref.child("user/profile/").child(userID!).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            
            self?.isLoading = false
            let userObj = snapshot.value as! [String: Any]
            self?.user = User(id: userObj["id"] as? String, nicNo: userObj["nic"] as? String, name: userObj["name"] as? String, email: userObj["email"] as? String, vehicleNo: userObj["vehicleNo"] as? String)
            
            completion(true)
        }) { (error) in
            print(error.localizedDescription)
            completion(true)
        }
        
    }
    
    func updateSlotByUserBookingData(user: User, slot: Slot, booknow: Bool, completion: @escaping CompletionApiHandler) {
        isLoading.toggle()
        ref.child("Parking/slots").queryOrdered(byChild: "id").queryEqual(toValue: slot.id).observeSingleEvent(of: .value) { [weak self] snapshot in
            
            self?.isLoading = false
            let userObj = snapshot.value as? [String: Any]
            print(userObj?.keys)
            
            let slotKeyArray = Array(userObj!.keys)
            let dateTime = self?.getDateString()
            
            let newSlot = Slot(id: slot.id ?? "", type: slot.type ?? "", user: booknow ? user : User(), time: dateTime, resurved: booknow)
            
            self?.ref.child("Parking/slots").child(slotKeyArray[0]).setValue(newSlot.nsDictionary) {
              (error:Error?, ref:DatabaseReference) in
              if let error = error {
                
                print("Data could not be saved: \(error).")
              } else {
               
                print("Data saved successfully!")
              }
                
                completion(true)
            }
            
        } withCancel: { error in
            print(error.localizedDescription)
            completion(true)
        }
        
    }
    
    func getDateString()-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = Date()

        print("This is UTC Date -> \(date)")

        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YYYY-MM-dd h:mm a"
        return dateFormat.string(from: date)
    }
}
