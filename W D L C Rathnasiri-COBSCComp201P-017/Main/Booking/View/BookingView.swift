//
//  BookingView.swift
//  W D L C Rathnasiri-COBSCComp201P-017
//
//  Created by Sahan Ravindu on 2021-11-08.
//

import SwiftUI
import FirebaseAuth
import UIKit

struct BookingView: View {
    
    //MARK: Variables
    @ObservedObject var vm = BookingVM()
    @ObservedObject var vmMain = MainVM()
    
    @State var slot: Slot
    @State var selectedSlot: Slot = Slot()
    @State var user: User = User()
    @State var name = ""
    @State var slotData = Slot()
    
    @State private var showAlert = false
    @State private var selectedFrameworkIndex = 0
    @State private var isScrollExpanded = false
    
    @State var showSlots = false
    @State private var selectedSlotId = ""
    @State var alredyReservedASlot = false
    
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
                        VStack {
                            Button {
                                withAnimation {
                                    showSlots.toggle()
                                }
                                
                            } label: {
                                let text: String = getSelectText()
                                Text(text).frame(width: 200, height: 50, alignment: .center).foregroundColor(.white).background(Color(slot.resurved ?? false ? .red : .blue)).cornerRadius(8)
                            }
                        }
                    }
                    
                    Button {
                        
                        UIApplication.shared.endEditing()
                        guard let _user = vm.user else {
                            return
                        }
                        
                        if selectedSlot.id == nil || selectedSlot.id == "" {
                            selectedSlot = slot
                        }
                        
                        vm.updateSlotByUserBookingData(user: _user, slot: selectedSlot, booknow: selectedSlot.resurved ?? false ? false : true) { status in
                            selectedSlot = Slot()
                            vmMain.bookedSlot = ""
                            
                            clearAllData()
                            loadProfile()
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
                    fetchData()
                    UITableView.appearance().separatorStyle = .none
                }.padding()
                .onDisappear {
                    clearAllData()
                }
                
                if vm.isLoading {
                    LoadingView(message: "Loading...")
                }
                
                if showSlots {
                    if alredyReservedASlot {
                        
                    } else {
                        VStack {
                            
                            List {
                                
                                ForEach(vm.slotList) { _slot in
                                    VStack {
                                        Button {
                                            if _slot.resurved ?? false {
                                                
                                            } else {
                                                selectedSlot = Slot(id: _slot.id ?? "", type: _slot.type ?? "", user: _slot.user ?? User(), time: _slot.time ?? "", resurved: _slot.resurved ?? false)
                                                //                                                slot = selectedSlot
                                                withAnimation {
                                                    showSlots.toggle()
                                                }
                                            }
                                        } label: {
                                            let text: String = "\(_slot.id ?? "") - \(_slot.type ?? "")"
                                            Text(text).foregroundColor(.white)
                                        }
                                    }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    //                                }
                                }
                                
                            }.listStyle(InsetListStyle())
                            
                            
                        }.background(Color(.gray))
                        .padding()
                        .cornerRadius(8)
                        
                    }
                }
                
            }
        }
        
    }
    
    func getValidSlotList()-> [Slot] {
        var slotList: [Slot] = []
        vm.mainVm.slotList.forEach { slot in
            if slot.resurved ?? false {
                if slot.user?.id == vm.user?.id {
                    DispatchQueue.main.async {
                        alredyReservedASlot = true
                        selectedSlot = slot
                        self.slot = slot
                        slotData = slot
                    }
                } else {
                    DispatchQueue.main.async {
                        alredyReservedASlot = false
                    }
                }
            } else {
                slotList.append(slot)
            }
        }
        
        return slotList
    }
    
    func fetchData() {
        loadProfile()
        getSlotList()
    }
    
    func getSlotList() {
        vm.geSlotList { staus in
            
        }
    }
    
    func loadProfile() {
        vm.getLoginProfile { status in
            if let _user = vm.user {
                vm.slotList = getValidSlotList()
                user = _user
                slotData = slot
            }
        }
    }
    
    func clearAllData() {
        slot = Slot()
        selectedSlot = Slot()
        slotData = Slot()
        vm.user = User()
    }
    
    func getSelectText()-> String {
        if !alredyReservedASlot {
            if selectedSlot.id != nil || selectedSlot.id != "" {
                return  "\(selectedSlot.id ?? "") - \(selectedSlot.type ?? "")"
            } else {
                return "Select a Slot"
            }
        } else {
            return "Select a Slot"
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
    
    var body: some View {
        VStack {
            Text("You have already select a slot")
            Button {
                HomeView()
            } label: {
                Text("Ok")
            }
            
        }
    }
}



//HStack(alignment: .firstTextBaseline) {
//    Text("Please choose a slot: ")
//    Spacer()
//}.frame(alignment: .leading)
////                            TextField("Selected Slot", text: $selectedSlotId).padding().background(Color(.secondarySystemBackground)).cornerRadius(8).disableAutocorrection(true).autocapitalization(.none)
////                                .disabled( slot.id != nil ? true : false)
//
////                            Form {
////                            Text("Select a slot >")
//    Section {
//        Picker(selection: $selectedSlotId, label: Text("Please choose a slot")) {
//
//            ForEach(vm.mainVm.slotList) { slot in
//                Text(slot.id ?? "")
//            }
//        }
//    }
////                            }
////                            Text("You selected: \(selectedSlotId)")
//}
