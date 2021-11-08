//
//  ForgotPasswordView.swift
//  Parking-Reservation
//
//  Created by Sahan Ravindu on 2021-11-04.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    //MARK: Variables
    @EnvironmentObject var vm: AuthManagerVM
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State var email    = ""
    
    var body: some View {
        ScrollView(.vertical) {
            ZStack {
                VStack {
                    Image("logo").resizable().scaledToFit().frame(width: 150, height: 150)
                    
                    VStack {
                        TextField("Email", text: $email).padding().background(Color(.secondarySystemBackground)).cornerRadius(8).disableAutocorrection(true).autocapitalization(.none)
    
                        Button {
                            
                            UIApplication.shared.endEditing()
                            if vm.isValidEmail(email) {
                                vm.resetPassword(email: email) { status in
                                    if status {
                                        DispatchQueue.main.async {
                                            self.presentationMode.wrappedValue.dismiss()
                                        }
                                    }
                                }
                            } else {
                                vm.response = ResponseData(title: "Error", message: "Please enter valid email", error:  .error("Please enter valid email"))
                                showAlert.toggle()
                            }
                            
                            
                        } label: {
                            Text("Reset Password").frame(width: 200, height: 50, alignment: .center).foregroundColor(.white).background(Color.blue).cornerRadius(8)
                        }.alert(isPresented: $showAlert) { // 4
                            
                            Alert(
                                title: Text(vm.response?.title ?? ""),
                                message: Text(vm.response?.message ?? "")
                            )
                            
                            
                        }.padding()
                    
                        
                    }.padding()
                    
                    Spacer()
                    
                }.navigationBarTitle("Forgot Password")
                
                if vm.isLoading {
                    LoadingView(message: "Sending reset password link to your email...")
                }
            }
        }.onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
