//
//  SignUpView.swift
//  MusicRecognitionApp02
//
//  Created by Dexter on 13/1/2023.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @Binding var currentShowingView: String
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    private func isValidPassword(_ password: String) -> Bool {
        
        // at least 6 characters
        // 1 uppercase character
        // 1 special char
        
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        
        return passwordRegex.evaluate(with: password)
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Text("Create Account Here!")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                }
                .padding()
                .padding(.top)
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                Text("Music Recognition App")
                    .foregroundColor(.white)
                    .font(.title2)
                Spacer()
                
                HStack {
                    Image(systemName: "mail")
                    TextField("Email", text: $email)
                    
                    Spacer()
                    
                    if(email.count != 0) {
                        Image(systemName: email.isValidEmail() ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(email.isValidEmail() ? .green : .red)
                    }
                    
                }
                .foregroundColor(.white)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.white)
                )
                .padding()
                
                HStack {
                    Image(systemName: "lock")
                    SecureField("password", text: $password)
                    
                    Spacer()
                    
                    if(password.count != 0) {
                        Image(systemName: isValidPassword(password) ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(isValidPassword(password) ? .green : .red)
                    }
                    
                }
                .foregroundColor(.white)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.white)
                )
                .padding()
                
                Button(action: {
                    withAnimation{self.currentShowingView = "login"}
                    
                }) {
                    Text("Already have an account?")
                }
                Spacer()
                Spacer()
             
                Button {
                    Auth.auth().createUser(withEmail: email, password: password)
                        {authResult, error in
                            if let error = error {
                                print(error)
                                return
                            }
                            if let authResult = authResult {
                                print(authResult)
                            }
                        }
                } label: {
                    Text("Create New Account")
                        .foregroundColor(.black)
                        .font(.title3)
                        .bold()
                    
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                        )
                        .padding(.horizontal)
                }

            }
        }
    }
}
