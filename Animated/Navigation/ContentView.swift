//
//  ContentView.swift
//  Animated
//
//  Created by Dang Hoang on 2022/05/27.
//

import SwiftUI
import RiveRuntime
import CoreData

struct ContentView: View {
    @AppStorage("selectedTab") var selectedTab: Tab = .chat
    @AppStorage("SelectedMenu") var selectedMenu: SelectedMenu = .home
    @State var isOpen = false
    @State var show = false
    
    let button = RiveViewModel(fileName: "menu_button", stateMachineName: "State Machine",autoPlay: false)
    
    var body: some View {
        ZStack {
            Color("Background 2")
                .ignoresSafeArea()
            SideMenu(isOpen: $isOpen)
                .opacity(isOpen ? 1 : 0)
                .offset(x: isOpen ? 0 : -300)
                .rotation3DEffect(.degrees(isOpen ? 0 : 30), axis: (x: 0, y: 1, z: 0))
            
            Group{
                switch selectedMenu {
                    case .home:
                        HomeView(isOpen: $isOpen, show: $show)
                    case .favorites:
                        FlashCardView()
                            .environmentObject(SpeechRecognizer())
                    case .search:
                        ListWordsView(predicate: Vocabulary.pridicate(with: false))
                    default:
                        Text("Hello world")
                }
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 80)
            }
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: 104)
            }
            .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .rotation3DEffect(.degrees(isOpen ? 30: 0), axis:  (x:0, y: -11, z: 0))
            .offset(x: isOpen ? 265 : 0)
            .scaleEffect(isOpen ? 0.9 : 1)
            .scaleEffect(show ? 0.92 : 1)
            .ignoresSafeArea()
            
            /*
            Image(systemName: "person")
                .frame(width: 36, height: 36)
                .background(.white)
                .mask(Circle())
                .shadow(color: Color("Shadow").opacity(0.2), radius: 5, x: 0, y: 5)
                .onTapGesture {
                    withAnimation(.spring()) {
                        show = true
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding()
                .offset(y: 4)
                .offset(x: isOpen ? 200 : 0)
            */
            button.view()
                .frame(width: 44, height: 44)
                .mask(Circle())
                .shadow(color: Color("Shadow").opacity(0.2), radius: 5, x: 0, y: 5)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding()
                .offset(x: isOpen ? 218 : 0)
                .onTapGesture {
                    //try? button.setInput("isOpen", value: isOpen)
                    //isOpen.toggle()
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        isOpen.toggle()
                    }
                }
                .onChange(of: isOpen) { newValue in
                    try? button.setInput("isOpen", value: !isOpen)
                    if newValue {
                        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
                    } else {
                        UIApplication.shared.setStatusBarStyle(.darkContent, animated: true)
                    }
                }
            /*
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
             */
            
            if show {
                OnBoardingView(show: $show)
                    .background(.white)
                    .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(color: .black.opacity(0.5), radius: 40, x: 0, y: 40)
                    .ignoresSafeArea(.all, edges: .top)
                    .transition(.move(edge: .top))
                    .offset(y: show ? -10 : 0)
                    .zIndex(1)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
