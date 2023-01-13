//
//  HomeView.swift
//  MusicRecognitionApp02
//
//  Created by Dexter on 13/1/2023.
//

import SwiftUI
import FirebaseAuth
import AVKit

struct HomeView: View {
    @AppStorage("uid") var userID: String = ""
    @State var record = false
    @State var session : AVAudioSession!
    @State var recorder : AVAudioRecorder!
    @State var alert = false
    
    var body: some View {
        NavigationView{
            VStack{
                Text("login success! \nYour uid is \(userID)")
                Spacer()
                
                Button (action: {
                    // record audio
                    do{
                        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

                        let filName = url.appendingPathComponent("myRecord.m4a")
                        
                        let settings = [
                        
                            AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
                            AVSampleRateKey : 12000,
                            AVNumberOfChannelsKey : 1,
                            AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue
                        
                        ]
                        
                        self.recorder = try AVAudioRecorder(url: filName, settings: settings)
                        self.recorder.record()
                        self.record.toggle()
                    }
                    catch{
                        print(error.localizedDescription)
                    }
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
        .alert(isPresented: self.$alert, content: {
            Alert(title: Text("Error"), message: Text("enable access"))
        })
        .onAppear{
            do{
                // Intializing
                self.session = AVAudioSession.sharedInstance()
                try self.session.setCategory(.playAndRecord)
                // requesting permission
                self.session.requestRecordPermission{
                    (status) in
                    if !status{
                        // error message
                        self.alert.toggle()
                    }
                }
            }
            catch{
                print(error.localizedDescription)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
