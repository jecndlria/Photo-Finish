import SwiftUI
import SwiftData

struct EntryListView: View {
    var entries: [FriendInfo]
    

    var body: some View {
        let sortedEntries = entries.sorted(by: { $0.totalPoints > $1.totalPoints })
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
    @State private var entries: [FriendInfo] = []
    @State private var showingAddFriend = false
    @State private var friendToAdd = ""
    @State private var pointsToAdd = ""
    
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
                Text("Welcome, \(UsernameManager.shared.username)")
                    .font(.title)
                    .foregroundColor(.white)
                //.bold()
                
                
                
                
                Button("Add Friend"){
                    showingAddFriend = true
                }
                .frame(width:200, height:40)
                .background(Color.blue.opacity(0.4))
                .foregroundColor(.white.opacity(0.6))
                .cornerRadius(10)
                EntryListView(entries: entries)
            }
        }.navigationDestination(isPresented: $showingAddFriend){
            Text("Welcome, ready to finish?")
            TextField("Username", text: $friendToAdd)
                .padding()
                .frame(width:300, height:60)
                .background(Color.white.opacity(0.08))
                .foregroundStyle(.red)
                .font(.subheadline)
                .cornerRadius(10)
                .autocorrectionDisabled(true)
                .autocapitalization(.none)
            TextField("Points", text: $pointsToAdd)
                .padding()
                .frame(width:300, height:60)
                .background(Color.white.opacity(0.08))
                .foregroundStyle(.red)
                .font(.subheadline)
                .cornerRadius(10)
                .autocorrectionDisabled(true)
                .autocapitalization(.none)
            Button("Add Friend"){
                addEntry()
            }
            .frame(width:200, height:40)
            .background(Color.blue.opacity(0.4))
            .foregroundColor(.white.opacity(0.6))
            .cornerRadius(10)
        }
    }
    
    private func addEntry() {
        let newEntry = FriendInfo(username: friendToAdd, totalPoints: pointsToAdd)
        entries.append(newEntry)
        friendToAdd = ""
        pointsToAdd = ""
        showingAddFriend = false
    }
}

struct ProfileLeaderboard_Previews:
    PreviewProvider{
    static var previews: some
        View{
            ProfileLeaderboard()
        }
}
