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
                    Image(systemName: "house")
                    Text("Home")
                }
            
//            BookingView(slot: Slot())
//                .tabItem {
//                    Image(systemName: "book")
//                    Text("Booking")
//                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Setting")
                }
            
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
