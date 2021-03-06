//
//  SignInView.swift
//  Animated
//
//  Created by Dang Hoang on 2022/05/27.
//

import SwiftUI
import RiveRuntime

struct SignInView: View {
    
    @State var email = ""
    @State var password = ""
    @State var isLoading = false
    @Binding var showModal: Bool
    @Binding var isValidated: Bool
    
    let check = RiveViewModel(fileName: "check", stateMachineName: "State Machine 1")
    let confetti = RiveViewModel(fileName: "confetti_explosion", stateMachineName: "State Machine 1")
    
    var body: some View {
        
        VStack(spacing: 24){
            Text("Sign In")
                .customFont(.largeTitle)
            Text("Access to 240+ hours of content. Learn design and code, by building real apps with React and Swift.")
                .customFont(.headline)
            
            VStack(alignment: .leading) {
                Text("Email")
                    .customFont(.subheadline)
                .foregroundColor(.secondary)
                TextField("", text: $email)
                    .customTextField()
            }
            
            VStack(alignment: .leading) {
                Text("Password")
                    .customFont(.subheadline)
                .foregroundColor(.secondary)
                SecureField("", text: $password)
                    .customTextField(image: Image("Icon Lock"))
            }
            
            Button{
                logIn()
            } label: {
                Label("Sign In", systemImage: "arrow.right")
                    .customFont(.headline)
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "F77D8E"))
                    .foregroundColor(.white)
                    .cornerRadius(20, corners: [.topRight, .bottomLeft, .bottomRight])
                    .cornerRadius(8, corners: [.topLeft])
                    .shadow(color: Color(hex: "F77D8E").opacity(0.5), radius: 20, x: 0, y: 10)
            }
            
            HStack {
                Rectangle().frame(height: 1).opacity(0.1)
                Text("OR").customFont(.subheadline2)
                    .foregroundColor(.black.opacity(0.3))
                Rectangle().frame(height: 1).opacity(0.1)
            }
            
            Text("Sign up with Email, Apple or Google")
                .customFont(.subheadline)
                .foregroundColor(.secondary)
            
            HStack{
                Image("Logo Email")
                Spacer()
                Image("Logo Apple")
                Spacer()
                Image("Logo Google")
            }
        }
        .padding(30)
        .background(.regularMaterial)
        .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color("Shadow").opacity(0.3), radius: 5, x: 0, y: 3)
        .shadow(color: Color("Shadow").opacity(0.3), radius: 30, x: 0, y: 30)
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous)
            .stroke(.linearGradient(colors: [.white.opacity(0.8), .white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)))
        
        .padding()
        .overlay(
            ZStack{
                if isLoading {
                    check.view()
                        .frame(width: 100, height: 100)
                        .allowsHitTesting(false)
                }
                confetti.view()
                    .scaleEffect(3)
                    .allowsHitTesting(false)
            }
        )
    }
    
    func logIn() {
        isLoading = true

        if email != "" {
            // Success DispatchQueue
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                try? check.setInput("Check", value: true)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                try? confetti.setInput("explosion", value: true)
                try? check.setInput("Check", value: false)
                try? check.setInput("Reset", value: true)
                isLoading = false
                isValidated = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                try? confetti.setInput("explosion", value: false)
                withAnimation {
                    showModal.toggle()
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                try? check.setInput("Error", value: true)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                try? check.setInput("Error", value: false)
                //try? check.setInput("Reset", value: true)
                isLoading = false
            }
        }
    }
    
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(showModal: .constant(true), isValidated: .constant(false))
    }
}
