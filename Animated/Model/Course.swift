//
//  Course.swift
//  Animated
//
//  Created by Dang Hoang on 2022/05/31.
//

import SwiftUI

struct Course: Identifiable {
    var id = UUID()
    
    var title: String
    var subtitle: String
    var caption: String
    var color: Color
    var image: Image
}

var courses = [
    Course(title: "Animations in SwiftUI", subtitle: "Build and animate an ios app from scratch", caption: "20 sections - 3 hours", color: Color(hex:"7850F0"), image: Image("Topic 1")),
    Course(title: "Build Quick Apps with SwiftUI", subtitle: "Apply your Swift and SwiftUI Knowledge by building real, quick and various applications from scratch", caption: "47 sections - 11 hours", color: Color(hex:"6792FF"), image: Image("Topic 2")),
    Course(title: "English Toeic", subtitle: "Your business needed testing course", caption: "47 sections - 11 hours", color: Color(hex:"6892FF"), image: Image("Topic 2"))
]
