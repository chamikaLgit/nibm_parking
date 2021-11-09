//
//  BookViewModel.swift
//  W D L C Rathnasiri-COBSCComp201P-017
//
//  Created by Sahan Ravindu on 2021-11-09.
//

import Foundation
import Firebase

class BookViewModel: ObservableObject {
    //MARK: Variable
    let auth = Auth.auth()
    var ref = Database.database().reference()
    @Published var isLoading = false
}
