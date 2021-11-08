//
//  AuthManagerView.swift
//  Parking-Reservation
//
//  Created by Sahan Ravindu on 2021-11-01.
//

import SwiftUI

struct AuthManagerView: View {
    
    //MARK: Variables
    @EnvironmentObject var vm: AuthManagerVM
    
    
    var body: some View {
        NavigationView {
            VStack {
                if vm.signedIn {
                    
                    HomeView()
                    
                } else {
                    SignInView()
                }
                
            }
        }
        .onAppear {
            vm.signedIn = vm.isSignedIn
        }
    }
    
}

struct AuthManagerView_Previews: PreviewProvider {
    static var previews: some View {
        AuthManagerView()
    }
}

extension View {
    func endEditing(_ force: Bool) {
        UIApplication.shared.windows.forEach { $0.endEditing(force)}
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
