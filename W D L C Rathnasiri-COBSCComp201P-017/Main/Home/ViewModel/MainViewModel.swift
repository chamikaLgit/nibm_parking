//
//  MainViewModel.swift
//  W D L C Rathnasiri-COBSCComp201P-017
//
//  Created by Sahan Ravindu on 2021-11-08.
//

import Foundation
import Firebase

class MainViewModel: ObservableObject {
    
    let semaphore = DispatchSemaphore(value: 1)
    @Published var slotList: [Slot] = []
    var ref = Database.database().reference()
    @Published var isLoading = false
    
    //Load student List
    func getSlotList(completion: @escaping CompletionApiHandler) {
        DispatchQueue.main.async {
            if !self.slotList.isEmpty {
                self.slotList.removeAll()
            }
        }
        self.ref.child("Parking/slots").observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            
            if snapshot.childrenCount > 0 {
                for student in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let slotObj = student.value as? [String: AnyObject]
                                        
                    let slot = Slot(id: slotObj?["id"] as? String, type: slotObj?["type"] as? String, user: slotObj?["user"] as? User, time: slotObj?["time"] as? String, resurved: slotObj?["resurved"] as? Bool)
                    
                    DispatchQueue.main.async {
                        self?.slotList.append(slot)
                    }
                    
                }
            }
           completion(true)
        }) { (error) in
            print(error.localizedDescription)
            completion(true)
        }
    }
    
    func getSlotListChanged() {
        
        self.ref.child("Parking/slots").observe(.childChanged, with: { [weak self] (snapshot) in
        
            let slotObj = snapshot.value as! [String: Any]
            print(slotObj)
            let slot = Slot(id: slotObj["id"] as? String, type: slotObj["type"] as? String, user: slotObj["user"] as? User, time: slotObj["time"] as? String, resurved: slotObj["resurved"] as? Bool)
            self?.saveAndUpdateSlot(newSlot: slot)
            
        }) { (error) in
            print(error.localizedDescription)
            
        }
        
    }
    
    func saveAndUpdateSlot(newSlot: Slot) {
        let tempSlot = self.slotList
        self.slotList.removeAll()
        
        tempSlot.forEach { slot in
            DispatchQueue.main.async {
                if newSlot.id == slot.id {
                    self.slotList.append(newSlot)
                } else {
                    self.slotList.append(slot)
                }
            }
        }
        
    }

}

enum types: String {
    case normal = "Normal"
    case vip = "VIP"
}



//func saveStudentData() {
//    
//    var slot: Slot?
//    
//    DispatchQueue.global(qos: .background).async {
//        for i in 0...24 {
//            self.semaphore.wait()
//            let dbReference = Database.database().reference().child("Parking/slots").childByAutoId()
//            
//            
//            if i != 1 || i != 2 || i != 3 || i != 4 {
//                slot = Slot(id: "00\(i+1)", type: types.normal.rawValue, user: nil, time: "", resurved: false)
//            } else {
//                slot = Slot(id: "00\(i+1)", type: types.vip.rawValue, user: nil, time: "", resurved: false)
//            }
//            dbReference.setValue(slot?.nsDictionary){error, ref in
//                defer {
//                    self.semaphore.signal()
//                }
//                
//            }
//        }
//    }
//    
//}
