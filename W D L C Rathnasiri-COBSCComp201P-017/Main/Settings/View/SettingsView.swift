//
//  SettingsView.swift
//  W D L C Rathnasiri-COBSCComp201P-017
//
//  Created by Sahan Ravindu on 2021-11-08.
//

import SwiftUI

struct SettingsView: View {
    //MARK: Variables
    @EnvironmentObject var vm: AuthManagerVM
    
    var body: some View {
        Button {
            //Sign Out
            vm.signOut()
            
        } label: {
            Text("Log Out").frame(width: 200, height: 50, alignment: .center).foregroundColor(.white).background(Color.blue).cornerRadius(8)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
