//
//  BookingView.swift
//  W D L C Rathnasiri-COBSCComp201P-017
//
//  Created by Sahan Ravindu on 2021-11-08.
//

import SwiftUI
import FirebaseAuth

struct BookingView: View {
    
    //MARK: Variables
    @ObservedObject var vm = BookingVM()
    @ObservedObject var vmMain = MainVM()
    let slot: Slot
    @State var user: User = User()
    @State var name = ""
    @State var slotData = Slot()
    @State private var showAlert = false
    @State private var selectedFrameworkIndex = 0
    @State private var isScrollExpanded = false
    @ObservedObject var vmDrop = MyModel(slots: [])
    
    var body: some View {
        ScrollView(.vertical) {
            ZStack {
                
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
                    
                    if slot.id != "" && slot.id != nil {
                        VStack {
                            HStack(alignment: .firstTextBaseline) {
                                Text("Slot No")
                                Spacer()
                            }.frame(alignment: .leading)
                            TextField("Selected Slot", text: $slotData.id.toUnwrapped(defaultValue: "")).padding().background(Color(.secondarySystemBackground)).cornerRadius(8).disableAutocorrection(true).autocapitalization(.none)
                                .disabled( slot.id != nil ? true : false)
                        }
                    } else {
                        ///////////// Drop down start
                        VStack {
                            HStack(alignment: .firstTextBaseline) {
                                Text("Slot No")
                                Spacer()
                            }.frame(alignment: .leading)
                            //                            let vm = MyModel(slots: vmMain.slotList)
                            //                            DropDownView(vm: vm)
                            HStack{
                                Text("Select : ")
                                DisclosureGroup(vmDrop.selection, isExpanded: $isScrollExpanded) {
                                    ScrollView {
                                        VStack(alignment: .leading, spacing: 8) {
                                            ForEach(vmDrop.newContents, id: \.self) { str in
                                                Text("\(str)")
                                                    .onTapGesture {
                                                        vmDrop.selection = str
                                                        withAnimation{
                                                            isScrollExpanded.toggle()
                                                        }
                                                    }
                                            }
                                        }.padding()
                                    }
                                }
                            }
                        }
                        
                        ///////////// Drop down end
                    }
                    
                    Button {
                        
                        UIApplication.shared.endEditing()
                        guard let _user = vm.user else {
                            return
                        }
                        vm.updateSlotByUserBookingData(user: _user, slot: slot, booknow: slot.resurved ?? false ? false : true) { status in
                            vmMain.bookedSlot = ""
                        }
                        if vm.isLoading {
                            
                        } else {
                            showAlert.toggle()
                        }
                        
                        
                    } label: {
                        let text: String = slot.resurved ?? false ? "Decline" : "Book Now"
                        Text(text).frame(width: 200, height: 50, alignment: .center).foregroundColor(.white).background(Color(slot.resurved ?? false ? .red : .blue)).cornerRadius(8)
                    }.alert(isPresented: $showAlert) {
                        Alert(
                            title: Text(vm.response?.title ?? ""),
                            message: Text(vm.response?.message ?? "")
                        )
                        
                    }.padding()
                    
                }.onAppear {
                    vm.getLoginProfile { status in
                        if let _user = vm.user {
                            user = _user
                            slotData = slot
                        }
                    }
                    
                    vmMain.getSlotList { status in
                        
                    }
                }.padding()
                
                if vm.isLoading {
                    LoadingView(message: "Loading...")
                }
            }
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


struct DropDownView: View {
    
    @State private var isScrollExpanded = false
    @ObservedObject var vm = MyModel(slots: [])
    
    var body: some View {
        HStack{
            Text("Select : ")
            DisclosureGroup(vm.selection, isExpanded: $isScrollExpanded) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(vm.newContents, id: \.self) { str in
                            Text("\(str)")
                                .onTapGesture {
                                    vm.selection = str
                                    withAnimation{
                                        isScrollExpanded.toggle()
                                    }
                                }
                        }
                    }.padding()
                }
            }
        }
    }
}

class MyModel: ObservableObject {
    @Published var selection = "Select a slot"
    var newContents: [String] = ["Yellow", "Blue", "Green", "White"]
    @State var slotList: [Slot] = []
    let userID = Auth.auth().currentUser?.uid
    
    init(slots: [Slot]) {
        slotList = slots
        createSlotArr()
    }
    
    func createSlotArr() {
        if slotList.count > 0 {
            slotList.forEach { slot in
                if slot.user?.id != userID {
                    if slot.user?.id == nil || slot.user?.id == "" {
                        newContents.append(slot.id ?? "")
                    }
                } else {
                    selection = "You have already booked a slot"
                    newContents = []
                    
                }
            }
        }
    }
    
}
