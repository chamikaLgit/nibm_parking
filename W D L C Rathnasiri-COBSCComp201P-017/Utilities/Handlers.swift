//
//  Handlers.swift
//  Parking-Reservation
//
//  Created by Sahan Ravindu on 2021-11-05.
//

import Foundation

typealias PermissionCompletionHandler = () -> Void
typealias CompletionApiHandler = (_ status: Bool) -> ()
typealias ActionHandler = (_ status: Bool, _ message: String) -> ()
typealias CompletionHandler = (_ status: Bool, _ code: Int, _ message: String) -> ()
typealias CompletionHandlerWithData = (_ status: Bool, _ code: Int, _ message: String, _ data: Any?) -> ()
typealias FileDownloadHandler = (_ status: Bool, _ message: String, _ url: String?) -> ()
typealias CompletionHandlerWithKeyValueData = (_ status: Bool, _ code: Int, _ message: String, _ keys: Any?, _ data: Any?) -> ()

func delay(_ delay: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
