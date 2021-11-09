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
                        
                        if isValidSlot(data: items) {
                            CollectionView(data: items)
                        } else {
                            NavigationLink(destination: BookingView(slot: items)) {
                                CollectionView(data: items)
                            }
                        }
                    }
                }
                if vm.isLoading {
                    LoadingView(message: "Loading...")
                }
            }.navigationBarTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                vm.getSlotList { status in }
                vm.getSlotListChanged()
            }
            
        }
        
    }
    
    func isValidSlot(data: Slot)-> Bool {
        if let _id = vm.auth.currentUser?.uid, let slotUserId = data.user?.id {
            if data.user == nil || slotUserId == _id {
                return true
            }
            return false
        } else {
            return false
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
        
//        NavigationLink(destination: isValidSlot() ? BookingView(slot: data) : nil) {
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
                        Spacer()
                        let status = self.data.resurved ?? false ? "Resrved" : "Free to book"
                        Text(status).foregroundColor(Color("f1"))
                        Spacer()
                        
                    }
                }
                
                
            }
//        }
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

