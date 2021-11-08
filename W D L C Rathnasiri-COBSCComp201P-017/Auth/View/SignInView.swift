//
//  SignInView.swift
//  Parking-Reservation
//
//  Created by Sahan Ravindu on 2021-11-03.
//

import SwiftUI

struct SignInView: View {
    
    //MARK: Variables
    @EnvironmentObject var vm: AuthManagerVM
    @State private var showAlert = false
    @State var email    = ""
    @State var password = ""
    
    var body: some View {
        ScrollView(.vertical) {
            ZStack {
                VStack {
                    Image("logo").resizable().scaledToFit().frame(width: 150, height: 150)
                    
                    VStack {
                        TextField("Email", text: $email).padding().background(Color(.secondarySystemBackground)).cornerRadius(8).disableAutocorrection(true).autocapitalization(.none)
                        
                        SecureField("Password", text: $password).padding().background(Color(.secondarySystemBackground)).cornerRadius(8).disableAutocorrection(true).autocapitalization(.none)
                        
                        HStack(alignment: .firstTextBaseline) {
                            NavigationLink("Forgot password?", destination: ForgotPasswordView()).fixedSize(horizontal: false, vertical: true)
                            
                            Spacer()

                        }.frame(alignment: .leading)
                        
                        Button {
                            //
                            print("Sign In Pressed")
                            
                            UIApplication.shared.endEditing()
                            if vm.validateForm(email: email, password: password) {
                                vm.signIn(email: email, password: password) { status in
                                    if !status {
                                        showAlert.toggle()
                                    }
                                }
                            } else {
                                showAlert.toggle()
                            }
                            
                            
                        } label: {
                            Text("Sign In").frame(width: 200, height: 50, alignment: .center).foregroundColor(.white).background(Color.blue).cornerRadius(8)
                        }.alert(isPresented: $showAlert) { // 4
                            
                            Alert(
                                title: Text(vm.response?.title ?? ""),
                                message: Text(vm.response?.message ?? "")
                            )
                            
                            
                        }.padding()
                        
                        
                        NavigationLink("Create Account", destination: SignUpView()).padding()
                        
                    }.padding()
                    
                    Spacer()
                    
                }.navigationBarTitle("Sign In")
                
                if vm.isLoading {
                    LoadingView(message: "Loged In...")
                }
            }.onTapGesture {
                UIApplication.shared.endEditing()
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
