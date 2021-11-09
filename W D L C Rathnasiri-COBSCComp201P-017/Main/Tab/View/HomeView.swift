//
//  HomeView.swift
//  Parking-Reservation
//
//  Created by Sahan Ravindu on 2021-11-03.
//

import SwiftUI

struct HomeView: View {
    
   
    
    var body: some View {
        
        TabView {
            MainView()
                .tabItem {
                    Label("Home", systemImage: "list.dash")
                }
            
//            BookView()
//                .tabItem {
//                    Label("Booking", systemImage: "list.dash")
//                }
            
            SettingsView()
                .tabItem {
                    Label("Setting", systemImage: "list.dash")
                }
            
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
