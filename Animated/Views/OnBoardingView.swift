//
//  OnBoardingView.swift
//  Animated
//
//  Created by Dang Hoang on 2022/05/27.
//

import SwiftUI
import RiveRuntime

struct OnBoardingView: View {
    let button = RiveViewModel(fileName: "button")
    @State var showModal = false
    @Binding var show: Bool
    @State var isValidated = false
    
    var body: some View {
        
        ZStack {
            background
            content
                .offset(y: showModal ? -50 : 0)
            Color("Shadow")
                .opacity(showModal ? 0.4 : 0)
                .ignoresSafeArea()
            
            if showModal {
                SignInView(showModal: $showModal, isValidated: $isValidated)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .overlay(
                        Button
                        {
                            withAnimation(.spring()){
                                showModal = false
                            }
                        }
                        label: {
                            Image(systemName: "xmark")
                                .frame(width: 36, height: 36)
                                .foregroundColor(.black)
                                .background(.white)
                                .mask(Circle())
                            .shadow(color: Color("Shadow").opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    )
                    .zIndex(1)
                    .onChange(of: isValidated) { newValue in
                        if newValue {
                            withAnimation {
                                show = false
                            }
                        }
                    }
            }
            
            Button{
                withAnimation {
                    show = false
                }
            }
            label:{
                Image(systemName: "xmark")
                    .frame(width: 36, height: 36)
                    .background(.black)
                    .foregroundColor(.white)
                    .mask(Circle())
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(20)
            .offset(y: showModal ? -200 : 80)
            
        }
    }
    var content: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Language Learner")
                .font(.custom("Poppins Bold", size: 50, relativeTo: .largeTitle))
                .frame(width: 260, alignment: .leading)
            
            Text("Don't skip design. Learn design and code. Learning language to improve your knowledges.")
                .customFont(.body)
                .opacity(0.7)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            button.view()
                .frame(width: 236, height: 64)
                .overlay(
                    Label("Start the course", systemImage: "arrow.forward")
                        .offset(x:4, y:4)
                        .font(.headline)
                )
                .background(
                    Color.black
                        .cornerRadius(30)
                        .blur(radius: 10)
                        .opacity(0.3)
                        .offset(y:10)
                )
                .onTapGesture {
                   try? button.play(animationName: "active")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        withAnimation(.spring()){
                            showModal = true
                        }
                    }
            }
            
        }
        .padding(40)
        .padding(.top, 40)
    }
    var background: some View {
        RiveViewModel(fileName: "myshapes").view()
            .ignoresSafeArea()
            .blur(radius: 50)
            .background(
                Image("Spline")
                    .blur(radius: 100)
                    .offset(x:200, y:100)
        )
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView(show: .constant(true))
    }
}
