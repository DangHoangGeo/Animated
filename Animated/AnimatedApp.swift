//
//  AnimatedApp.swift
//  Animated
//
//  Created by Dang Hoang on 2022/05/27.
//

import SwiftUI

@main
struct AnimatedApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
