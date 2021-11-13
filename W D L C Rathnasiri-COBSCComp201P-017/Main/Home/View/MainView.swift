//
//  MainView.swift
//  W D L C Rathnasiri-COBSCComp201P-017
//
//  Created by Sahan Ravindu on 2021-11-08.
//

import SwiftUI

struct MainView: View {
    
    //MARK: Variables
    @ObservedObject var vm = MainVM()
    @State private var showAlert = false
    @State var pressed: Int = -1
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        VStack {
            DetailView()
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(vm.slotList) { items in
                        
                        if items.id == vm.bookedSlot || !(items.resurved ?? false) && (vm.bookedSlot == "") {
                            NavigationLink(destination: BookingView(slot: items)) {
                                CollectionView(data: items)
                            }
                        } else {
                            CollectionView(data: items).gesture(TapGesture().onEnded({ _ in
                                vm.response = ResponseData(title: "Warning", message: "You have already booked a slot.", error: .error(""))
                                showAlert.toggle()
                            }))
                        }
                    }
                }
                if vm.isLoading {
                    LoadingView(message: "Loading...")
                }
            }.navigationBarTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                vm.bookedSlot = ""
                vm.getSlotList {status in
                    
                }
                vm.getSlotListChanged()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(vm.response?.title ?? ""),
                    message: Text(vm.response?.message ?? "")
                )
            }.padding()
            
        }
        
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}


struct CollectionView: View {
    
    @ObservedObject var vm = MainVM()
    let data: Slot
    let width = (UIScreen.main.bounds.width/3)+20
    @State private var isBookingView = false
    
    var body: some View {
        ZStack {
            
            if data.type == types.vip.rawValue {
                RoundedRectangle(cornerRadius: 8).frame(width: width, height: width, alignment: .center).foregroundColor(Color( data.resurved ?? false ? .red : .orange ))
            } else {
                RoundedRectangle(cornerRadius: 8).frame(width: width, height: width, alignment: .center).foregroundColor(Color( data.resurved ?? false ? .red : .green ))
            }
            
            VStack {
                
                VStack {
                    Spacer()
                    Text(self.data.type ?? "").foregroundColor(Color("f1"))
                    if self.data.resurved ?? false {
                        Spacer()
                        Text(self.data.user?.vehicleNo ?? "").foregroundColor(Color("f1"))
                        
                        if self.data.user?.id ?? "" == vm.auth.currentUser?.uid ?? "" {
                            Spacer()
                            HStack {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 10, height: 10)
                                Text("You slot").foregroundColor(Color("f1"))
                            }
                        }
                    }
                    Spacer()
                    let status = self.data.resurved ?? false ? "Resrved" : "Free to book"
                    Text(status).foregroundColor(Color("f1"))
                    Spacer()
                    
                }
            }
        }
    }
    
}

struct CollectionViewPreviews: PreviewProvider {
    static var previews: some View {
        CollectionView(data: Slot())
    }
}

struct DetailView: View {
    
    var body: some View {
        HStack{
            HStack{
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 10, height: 10)
                Text("VIP")
            }
            HStack{
                Circle()
                    .fill(Color.green)
                    .frame(width: 10, height: 10)
                Text("Normal")
            }
            HStack{
                Circle()
                    .fill(Color.red)
                    .frame(width: 10, height: 10)
                Text("Reserved")
            }
            
        }
    }
}


struct DetailViewPreviews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}

