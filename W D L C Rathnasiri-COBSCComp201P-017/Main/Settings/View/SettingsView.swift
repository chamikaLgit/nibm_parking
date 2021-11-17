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
    @ObservedObject var bookingVM = BookingVM()
    @State private var showAlert = false
    @State var user: User = User()
    
    var body: some View {
        ScrollView(.vertical) {
            ZStack {
                VStack {
                    
                    HStack(alignment: .firstTextBaseline) {
                        Text("Name: ")
                        Text(user.name ?? "").padding()
                        Spacer()
                    }.frame(alignment: .leading)
                    
                    HStack(alignment: .firstTextBaseline) {
                        Text("Email: ")
                        Text(user.email ?? "").padding()
                        Spacer()
                    }.frame(alignment: .leading)
                    
                    HStack(alignment: .firstTextBaseline) {
                        Text("Vehicle No: ")
                        Text(user.vehicleNo ?? "").padding()
                        Spacer()
                    }.frame(alignment: .leading)
                    
                    Button {
                        //Sign Out
                        showAlert.toggle()
                        
                    } label: {
                        Text("Log Out").frame(width: 200, height: 50, alignment: .center).foregroundColor(.white).background(Color.blue).cornerRadius(8)
                    }.alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Warning"),
                            message: Text("Are you sure you want to logout?"),
                            primaryButton: .default(Text("No"), action: {
                                
                            }),
                            secondaryButton: .default(Text("Yes"), action: {
                                vm.signOut()
                            })
                        )
                        
                    }.padding()
                }.onAppear {
                    loadProfile()
                }.padding()
                
                if bookingVM.isLoading {
                    LoadingView(message: "Loading profile...")
                }
                
            }
        }
        
       
    }
    
    func loadProfile() {
        bookingVM.getLoginProfile { status in
            if let _user = bookingVM.user {
                user = _user
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
