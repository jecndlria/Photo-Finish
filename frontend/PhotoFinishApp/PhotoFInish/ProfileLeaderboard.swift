import SwiftUI
import SwiftData
import AWSCore
import AWSLambda

struct EntryListView: View {
    //var entries: [FriendInfo]
    @ObservedObject var friendInfoManager: FriendInfoManager
    var body: some View {
        let sortedEntries = friendInfoManager.entries.sorted(by: { $0.totalPoints > $1.totalPoints })
        List {
            ForEach(sortedEntries, id: \.self) { entry in
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.4))
                    .overlay(
                        HStack {
                            Text(entry.username)
                                .foregroundColor(.white)
                                .padding()
                            Spacer()
                            Text(entry.totalPoints)
                                .foregroundColor(.white)
                                .padding()
                        }
                    )
                    .background(Color.black)
                    .listRowBackground(Color.clear)
            }
        }
            .listStyle(PlainListStyle())
            .background(Color.black)
    }
}

struct ProfileLeaderboard: View{
    @ObservedObject var friendInfoManager = FriendInfoManager.shared
    @State private var showingAddFriend = false
    @State private var friendToAdd = ""
    @State private var wrongUsername = 0
    @State private var printedOutput = ""
    struct RedirectedOutputStream: TextOutputStream {
            var target: ProfileLeaderboard

            mutating func write(_ string: String) {
                target.printedOutput.append(string)
            }
        }
    func addFriend(username: String, friend: String){
        let lambda = AWSLambda.default()
        let request = AWSLambdaInvocationRequest()
        request!.functionName = "new_friend"
        request!.invocationType = .requestResponse
        request!.payload = "{\"username\": \"\(username)\", \"friend\": \"\(friend)\"}".data(using: .utf8)
        lambda.invoke(request!) { (response, error) in
                    if let error = error {
                        print("Error invoking Lambda function: \(error)")
                    } else if let payload = response?.payload {
                        //as? Data, let payloadString = String(data: payload, encoding: .utf8)
                        // Handle the response payload here
                        print("Lambda function response: \(payload)")
                        var outputStream = RedirectedOutputStream(target: self)
                        print("\(payload)", to: &outputStream)
                        print("Captured output: \(printedOutput)")
                        if printedOutput.contains("200") {
                            printedOutput = ""
                            
//                            friendInfoManager.entries.removeAll()
//                            getFriends(username: UsernameManager.shared.username)
                            
                            friendToAdd = ""
                            showingAddFriend = false
                        }else{
                            wrongUsername = 2
                            printedOutput = ""
                        }
                    }
                }
    }
    func removeFriend(username: String, friend: String){
        let lambda = AWSLambda.default()
        let request = AWSLambdaInvocationRequest()
        request!.functionName = "remove_friend"
        request!.invocationType = .requestResponse
        request!.payload = "{\"username\": \"\(username)\", \"friend\": \"\(friend)\"}".data(using: .utf8)
        lambda.invoke(request!) { (response, error) in
                    if let error = error {
                        print("Error invoking Lambda function: \(error)")
                    } else if let payload = response?.payload {
                        //as? Data, let payloadString = String(data: payload, encoding: .utf8)
                        // Handle the response payload here
                        print("Lambda function response: \(payload)")
                        var outputStream = RedirectedOutputStream(target: self)
                        print("\(payload)", to: &outputStream)
                        print("Captured output: \(printedOutput)")
                        if printedOutput.contains("200") {
                            printedOutput = ""
                            
                            
//                            friendInfoManager.entries.removeAll()
//                            getFriends(username: UsernameManager.shared.username)
                            
                            friendToAdd = ""
                            showingAddFriend = false
                        }else{
                            wrongUsername = 2
                            printedOutput = ""
                        }
                    }
                }
    }
    func getFriends(username: String){
        let lambda = AWSLambda.default()
        let request = AWSLambdaInvocationRequest()
        request!.functionName = "get_leaderboard"
        request!.invocationType = .requestResponse
        request!.payload = "{\"username\": \"\(username)\"}".data(using: .utf8)
        lambda.invoke(request!) { (response, error) in
                    if let error = error {
                        print("Error invoking Lambda function: \(error)")
                    } else if let payload = response?.payload {
                        //as? Data, let payloadString = String(data: payload, encoding: .utf8)
                        // Handle the response payload here
                        print("Lambda function response: \(payload)")
                        var outputStream = RedirectedOutputStream(target: self)
                        print("\(payload)", to: &outputStream)
                        print("Captured output: \(printedOutput)")
                        if printedOutput.contains("200") {
                            let components = printedOutput.split { $0 == "," || $0 == "\n" }
                            for component in components {
                                let keyValue = component.split(separator: "=")
                                print(keyValue)
                                guard keyValue.count == 2 else {
                                    continue
                                }
                                let key = keyValue[0].trimmingCharacters(in: .whitespaces)
                                let value = keyValue[1].trimmingCharacters(in: .whitespaces)
                                
                                let cleanedKey = key.replacingOccurrences(of: "\"", with: "")
                                let cleanedValue = value.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: ";", with: "")
                                
                                print(cleanedKey)
                                print(cleanedValue)
                                
                                if cleanedKey != "statusCode" && cleanedKey != "body" && cleanedKey != "payload" {
                                    let newEntry = FriendInfo(username: cleanedKey, totalPoints: cleanedValue)
                                        friendInfoManager.entries.append(newEntry)
                                }
                                for entry in friendInfoManager.entries {
                                    print("Username: \(entry.username), Points: \(entry.totalPoints)")
                                }
                            }
                            printedOutput = ""
                        }else{
                            wrongUsername = 2
                            printedOutput = ""
                        }
                    }
                }
    }
    
//    init(){
//        getFriends(username: UsernameManager.shared.username)
//    }
    
    var body: some View{
        ZStack{
            Color.black
                .ignoresSafeArea()
            VStack{
                Text(String(UsernameManager.shared.username.first ?? " "))
                    .font(.system(size: 100))
                    .foregroundColor(.white)
                    .frame(width: 200, height: 200)
                    .background(Color.gray)
                    .clipShape(Circle())
                    .onAppear{
                        friendInfoManager.entries.removeAll()
                        getFriends(username: UsernameManager.shared.username)
                    }
                Text("Welcome, \(UsernameManager.shared.username)")
                    .font(.title)
                    .foregroundColor(.white)
                //.bold()
                
                
                
                
                Button("Manage Follows"){
                    showingAddFriend = true
                }
                .frame(width:200, height:40)
                .background(Color.blue.opacity(0.4))
                .foregroundColor(.white.opacity(0.6))
                .cornerRadius(10)
                EntryListView(friendInfoManager: friendInfoManager)
            }
        }.navigationDestination(isPresented: $showingAddFriend){
            ZStack{
                Color.black
                    .ignoresSafeArea()
                VStack{
                    Text("Enter username of follow")
                        .foregroundColor(.white)
                    TextField("Username", text: $friendToAdd)
                        .padding()
                        .frame(width:300, height:60)
                        .background(Color.white.opacity(0.08))
                        .foregroundStyle(.red)
                        .font(.subheadline)
                        .cornerRadius(10)
                        .autocorrectionDisabled(true)
                        .autocapitalization(.none)
                    Button("Follow"){
                        addEntry()
                    }
                    .frame(width:200, height:40)
                    .background(Color.blue.opacity(0.4))
                    .foregroundColor(.white.opacity(0.6))
                    .cornerRadius(10)
                    Button("Unfollow"){
                        removeEntry()
                    }
                    .frame(width:200, height:40)
                    .background(Color.blue.opacity(0.4))
                    .foregroundColor(.white.opacity(0.6))
                    .cornerRadius(10)
                }
            }
        }
    }
    
    private func addEntry() {
        addFriend(username: UsernameManager.shared.username, friend: friendToAdd)
//        let newEntry = FriendInfo(username: friendToAdd, totalPoints: pointsToAdd)
//        FriendInfoManager.entries.append(newEntry)
        
//        friendInfoManager.entries.removeAll()
//        getFriends(username: UsernameManager.shared.username)
//        
//        friendToAdd = ""
//        pointsToAdd = ""
        //showingAddFriend = false
    }
    private func removeEntry() {
        removeFriend(username: UsernameManager.shared.username, friend: friendToAdd)
//        FriendInfoManager.entries.removeAll { $0.username == friendToAdd }
        
//        friendInfoManager.entries.removeAll()
//        getFriends(username: UsernameManager.shared.username)
//        
//        friendToAdd = ""
//        pointsToAdd = ""
//        showingAddFriend = false
    }

}

struct ProfileLeaderboard_Previews:
    PreviewProvider{
    static var previews: some
        View{
            ProfileLeaderboard()
        }
}
