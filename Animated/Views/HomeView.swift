//
//  HomeView.swift
//  Animated
//
//  Created by Dang Hoang on 2022/05/31.
//

import SwiftUI

struct HomeView: View {
    @Binding var isOpen : Bool
    @Binding var show : Bool
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            ScrollView {
                content
            }
            
            TabBar()
                .offset(y: isOpen ? 300 : 0)
                .offset(y: show ? 200 : 0)
                .offset(y: -24)
                .background(
                    LinearGradient(colors: [Color("Background").opacity(0), Color("Background").opacity(0.5)], startPoint: .top, endPoint: .bottom)
                        .frame(height: isOpen ? 0 : 110)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .allowsTightening(false)
                )
                .ignoresSafeArea()
        }
    }
    
    var content: some View {
            VStack(alignment: .leading, spacing: 0){
                Text("Courses")
                    .customFont(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(courses ) { course in
                            VCard(course: course)
                        }
                    }
                    .padding(20)
                    .padding(.bottom, 10)
                }
                
                Text("Recent")
                    .customFont(.title3)
                    .padding(.horizontal, 20)
                
                VStack(spacing: 20) {
                    ForEach(courseSection) { section in
                        HCard(section: section)
                    }
                }
                .padding(20)
            }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(isOpen: .constant(false), show: .constant(false))
    }
}
