import SwiftUI

struct ContentView: View {
    @AppStorage("uid") var userID: String = ""
    
    var body: some View {
        
        if userID == ""{
            AuthView()
        }else{
            Text("success!")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
