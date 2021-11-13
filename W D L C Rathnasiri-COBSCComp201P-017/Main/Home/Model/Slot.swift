//
//  Slot.swift
//  W D L C Rathnasiri-COBSCComp201P-017
//
//  Created by Sahan Ravindu on 2021-11-08.
//

import Foundation
import SwiftUI

struct Slot: Identifiable {
    var id: String?
    var type: String?
    var user: User?
    var time: String?
    var resurved: Bool?
    
    var dictionary: [String: Any] {
        return [
                "id": id ?? "",
                "type": type ?? "",
                "user": user?.nsDictionary ?? NSDictionary.self,
                "time": time ?? "",
                "resurved": resurved ?? false
               ]
    }
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}

