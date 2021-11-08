//
//  ResponseData.swift
//  Parking-Reservation
//
//  Created by Sahan Ravindu on 2021-11-03.
//

import Foundation
import UIKit

struct ResponseData: Identifiable {
    let title: String
    var id: String {
        title
    }
    let message: String
    
    enum ErrorType {
        case none
        case error(String)
    }
    let error: ErrorType
}
