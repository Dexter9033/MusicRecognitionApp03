import SwiftUI
import FirebaseAuth
import AVKit

struct ContentView: View {
    @AppStorage("uid") var userID: String = ""
    
    var body: some View {
        
        if userID == ""{
            AuthView()
        }else{
            Home()
                .preferredColorScheme(.dark)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct Home : View {
    
    @State var record = false
    // creating instance for recroding
    @State var session : AVAudioSession!
    @State var recorder : AVAudioRecorder!
    @State var alert = false
    // Fetch Audios
    @State var audios : [URL] = []
    
    var body: some View{
        
        NavigationView{
            
            VStack{
                
                List(self.audios,id: \.self){i in
                    
                    // printing only file name...
                    
                    Text(i.relativeString)
                }
                
                
                Button(action: {

                    // record audio and store audio in document directory
                    do{
                        
                        if self.record{
                            
                            // Already Started Recording means stopping and saving.
                            self.recorder.stop()
                            self.record.toggle()
                            // updating data for every record
                            self.getAudios()
                            return
                        }
                        
                        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        
                        // same file name...
                        // so were updating based on audio count...
                        let filName = url.appendingPathComponent("myRecord\(self.audios.count + 1).m4a")
                        
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
                    
                    
                }) {
                    
                    ZStack{
                        
                        Circle()
                            .fill(Color.red)
                            .frame(width: 70, height: 70)
                        
                        if self.record{
                            
                            Circle()
                                .stroke(Color.white, lineWidth: 6)
                                .frame(width: 85, height: 85)
                        }
                    }
                }
                .padding(.vertical, 25)
            }
            .navigationBarTitle("Record Audio")
        }
        .alert(isPresented: self.$alert, content: {
            
            Alert(title: Text("Error"), message: Text("Enable Acess"))
        })
        .onAppear {
            
            do{
                
                self.session = AVAudioSession.sharedInstance()
                try self.session.setCategory(.playAndRecord)
                
                // requesting permission
                self.session.requestRecordPermission { (status) in
                    
                    if !status{
                        
                        // error message
                        self.alert.toggle()
                    }
                    else{
                        
                        // fetching all data when permission granted
                        
                        self.getAudios()
                    }
                }
                
                
            }
            catch{
                
                print(error.localizedDescription)
            }
        }
    }
    
    func getAudios(){
        
        do{
            
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            // fetch all data from document directory
            
            let result = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .producesRelativePathURLs)
            
            // updated means remove all old data
            
            self.audios.removeAll()
            
            for i in result{
                
                self.audios.append(i)
            }
        }
        catch{
            
            print(error.localizedDescription)
        }
    }
}
