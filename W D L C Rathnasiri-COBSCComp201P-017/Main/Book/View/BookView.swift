//
//  BookView.swift
//  W D L C Rathnasiri-COBSCComp201P-017
//
//  Created by Sahan Ravindu on 2021-11-08.
//

import SwiftUI

struct BookView: View {
    
    //MARK: Variables
    @ObservedObject var vm = MainVM()
    let slot: Slot
    
    var body: some View {
        Text(slot.type ?? "")
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView(slot: Slot())
    }
}
