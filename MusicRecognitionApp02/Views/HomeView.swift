//
//  HomeView.swift
//  MusicRecognitionApp02
//
//  Created by Dexter on 13/1/2023.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @AppStorage("uid") var userID: String = ""
    @State var record = false
    
    var body: some View {
        NavigationView{
            VStack{
                Text("login success! \nYour uid is \(userID)")
                Spacer()
                
                Button (action: {
                    self.record.toggle()
                }) { ZStack{
                    Circle()
                        .fill(.red)
                        .frame(width: 70, height: 70)
                    if self.record{
                         Circle()
                            .stroke(.white, lineWidth: 6)
                            .frame(width: 84, height: 84)
                    }
                }}.padding()

                
                Button(action: {
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                        withAnimation {
                            userID = ""
                        }
                    } catch let signOutError as NSError {
                        print("Error signing out: %@", signOutError)
                    }
                }) {
                    Text("Sign Out")
                        .padding(.horizontal)
                }
            }.navigationTitle("Record Audio")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
