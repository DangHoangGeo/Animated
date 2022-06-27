//
//  SearchBarView.swift
//  Animated
//
//  Created by Dang Hoang on 2022/06/06.
//

import SwiftUI

struct SearchBarView: View {
    @State var searchKey: String = ""
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundColor(.black)
                .padding()
            TextField("Search...", text: $searchKey)
        }
        .background(Color.white)
        .cornerRadius(30)
        .padding(.horizontal, 25)
        .padding(.bottom)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView()
    }
}
