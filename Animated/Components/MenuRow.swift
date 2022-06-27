//
//  MenuRow.swift
//  Animated
//
//  Created by Dang Hoang on 2022/06/01.
//

import SwiftUI

struct MenuRow: View {
    var item: MenuItem
    @Binding var selectedMenu: SelectedMenu
    
    var body: some View {
        HStack(spacing: 14) {
            item.icon.view()
                .frame(width: 32, height: 32)
            .opacity(0.6)
            
            Text(item.text)
                .customFont(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background{
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(hex: "FFFFFF").opacity(0.2))
                .shadow(color: Color("Shadow").opacity(0.3), radius: 5, x: 0, y: 3)
                .shadow(color: Color("Shadow").opacity(0.3), radius: 10, x: 0, y: 10)
                .frame(maxWidth: selectedMenu == item.menu ? .infinity : 0)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color("Background 2"))
        .onTapGesture {
            try? item.icon.setInput("active", value: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                try? item.icon.setInput("active", value: false)
            }
            withAnimation(.timingCurve(0.2, 0.8, 0.2, 1)) {
                selectedMenu = item.menu
            }
        }
    }
}

struct MenuRow_Previews: PreviewProvider {
    static var previews: some View {
        MenuRow(item: menuItems[1], selectedMenu: .constant(.home))
    }
}
