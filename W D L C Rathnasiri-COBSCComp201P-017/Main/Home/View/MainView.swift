//
//  MainView.swift
//  W D L C Rathnasiri-COBSCComp201P-017
//
//  Created by Sahan Ravindu on 2021-11-08.
//

import SwiftUI

struct MainView: View {
    
    //MARK: Variables
    @ObservedObject var vm = MainViewModel()
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            //            List(vm.slotList) { slot in
            //
            //                CollectionView(data: slot)
            //            }
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(vm.slotList) { items in
                    CollectionView(data: items)
                }
            }
            
            
        }.navigationBarTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            print("DetailView appeared!")
            vm.getSlotList { status in }
            vm.getSlotListChanged()
        }
        
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}


struct CollectionView: View {
    let data: Slot
    let width = (UIScreen.main.bounds.width/3)+20
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8).frame(width: width, height: width, alignment: .center).foregroundColor(Color( data.resurved ?? false ? .red : .green))
            //forgroundColor( Color( data.resurved ?? false ? .red : .green).ignoresSafeArea())
            
            VStack {
                
                VStack {
                    Spacer()
                    Text(self.data.type ?? "")
                    Spacer()
                    let status = self.data.resurved ?? false ? "Resrved" : "Free"
                    Text(status)
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
