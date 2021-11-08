//
//  User.swift
//  W D L C Rathnasiri-COBSCComp201P-017
//
//  Created by Sahan Ravindu on 2021-11-08.
//

import Foundation

struct User: Codable {
    var nicNo: String?
    var name: String?
    var email: String?
    var vehicleNo: String?
    
    enum CodingKeys: String, CodingKey {
        case nicNo
        case name, email, vehicleNo
    }
    
    var dictionary: [String: Any] {
        return [
                "nic": nicNo ?? "",
                "name": name ?? "",
                "email": email ?? "",
                "vehicleNo": vehicleNo ?? ""
               ]
    }
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}
