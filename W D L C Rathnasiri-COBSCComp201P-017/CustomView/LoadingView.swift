//
//  LoadingView.swift
//  Parking-Reservation
//
//  Created by Sahan Ravindu on 2021-11-03.
//

import SwiftUI

struct LoadingView: View {
    
    let message: String
    var body: some View {
        ZStack {
            Color(.systemBackground).opacity(0.4)
                .ignoresSafeArea()
            ProgressView(message)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemBackground)))
        }
            .shadow(radius: 10)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(message: "")
    }
}
