//
//  BookingView.swift
//  W D L C Rathnasiri-COBSCComp201P-017
//
//  Created by Sahan Ravindu on 2021-11-08.
//

import SwiftUI

struct BookingView: View {
    
    //MARK: Variables
    @ObservedObject var vm = BookingVM()
    let slot: Slot
    @State var user: User = User()
    @State var name = ""
    @State var slotData = Slot()
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                VStack {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Regitrstion No")
                        Spacer()
                    }.frame(alignment: .leading)
                    TextField("User ID", text: $user.id.toUnwrapped(defaultValue: "")).padding().background(Color(.secondarySystemBackground)).cornerRadius(8).disableAutocorrection(true).autocapitalization(.none).disabled(true)
                }
                VStack {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Vehicle No")
                        Spacer()
                    }.frame(alignment: .leading)
                    TextField("Vehicle No", text: $user.vehicleNo.toUnwrapped(defaultValue: "")).padding().background(Color(.secondarySystemBackground)).cornerRadius(8).disableAutocorrection(true).autocapitalization(.none).disabled(true)
                }
                VStack {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Slot No")
                        Spacer()
                    }.frame(alignment: .leading)
                    TextField("Selected Slot", text: $slotData.id.toUnwrapped(defaultValue: "")).padding().background(Color(.secondarySystemBackground)).cornerRadius(8).disableAutocorrection(true).autocapitalization(.none)
                }
                
            }.onAppear {
                print("BOOKING VIEW")
                vm.getLoginProfile { status in
                    if let _user = vm.user {
                        user = _user
                        slotData = slot
                    }
                }
            }.padding()
        }
    }
    
    
}

struct BookingView_Previews: PreviewProvider {
    static var previews: some View {
        BookingView(slot: Slot())
    }
}

extension Binding {
    func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}
