//
//  W_D_L_C_Rathnasiri_COBSCComp201P_017App.swift
//  W D L C Rathnasiri-COBSCComp201P-017
//
//  Created by Sahan Ravindu on 2021-11-07.
//

import SwiftUI
import Firebase

@main
struct W_D_L_C_Rathnasiri_COBSCComp201P_017App: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            let vm = AuthManagerVM()
            AuthManagerView()
                .environmentObject(vm)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        return true
    }
}
