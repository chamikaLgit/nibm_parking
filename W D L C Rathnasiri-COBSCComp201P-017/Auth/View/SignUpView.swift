//
//  SignUpView.swift
//  Parking-Reservation
//
//  Created by Sahan Ravindu on 2021-11-03.
//

import SwiftUI

struct SignUpView: View {
    
    //MARK: Variables
    @EnvironmentObject var vm: AuthManagerVM
    @State var email    = ""
    @State var password = ""
    @State var nic      = ""
    @State var name     = ""
    @State var vehicleNO = ""
    @State private var showAlert = false
    
    private enum Field: Int, CaseIterable {
        case email, password
    }
    
    var body: some View {
        ScrollView(.vertical) {
            ZStack {
                VStack {
                    Image("logo").resizable().scaledToFit().frame(width: 150, height: 150)
                    
                    VStack {
                        TextField("NIC", text: $nic).padding().background(Color(.secondarySystemBackground)).cornerRadius(8).disableAutocorrection(true).autocapitalization(.none)
                        TextField("Name", text: $name).padding().background(Color(.secondarySystemBackground)).cornerRadius(8).disableAutocorrection(true).autocapitalization(.none)
                        TextField("Vehicle No", text: $vehicleNO).padding().background(Color(.secondarySystemBackground)).cornerRadius(8).disableAutocorrection(true).autocapitalization(.none)
                        TextField("Email", text: $email).padding().background(Color(.secondarySystemBackground)).cornerRadius(8).disableAutocorrection(true).autocapitalization(.none)
                        SecureField("Password", text: $password).padding().background(Color(.secondarySystemBackground)).cornerRadius(8).disableAutocorrection(true).autocapitalization(.none)
                        Button {
                            UIApplication.shared.endEditing()
                            if vm.validateForm(email: email, password: password) {
                                
                                vm.user = User(id: vm.auth.currentUser?.uid, nicNo: nic, name: name, email: email, vehicleNo: vehicleNO)
                                vm.signUp(email: email, password: password) { status in
                                    if !status {
                                        showAlert.toggle()
                                    }
                                }
                            } else {
                                showAlert.toggle()
                            }
                            
                        } label: {
                            Text("Create Account").frame(width: 200, height: 50, alignment: .center).foregroundColor(.white).background(Color.blue).cornerRadius(8)
                        }.alert(isPresented: $showAlert) { // 4
                            
                            Alert(
                                title: Text(vm.response?.title ?? ""),
                                message: Text(vm.response?.message ?? "")
                            )
                            
                            
                        }.padding()
                        
                        
                    }.padding()
                    
                    Spacer()
                    
                }.navigationBarTitle("Sign Up")
                
                if vm.isLoading {
                    LoadingView(message: "Creating account..")
                }
                
            }.onTapGesture {
                UIApplication.shared.endEditing()
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
