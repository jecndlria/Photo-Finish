import SwiftUI
import SwiftData

struct EmailLogin: View {
    @State private var username = ""
    @State private var password = ""
    @State private var wrongUsername = 0
    @State private var wrongPassword = 0
    @State private var showingLoginScreen = false
    var body: some View{
        NavigationStack{
            ZStack{
                Color.black
                    .ignoresSafeArea()
                VStack{
                    Text("📸💥")
                        .font(.system(size: 50))
                        .padding()
                    Text("Lets start, what's your login?")
                        .foregroundStyle(.white)
                        .bold()
                        .font(.system(size: 25))
                        .multilineTextAlignment(.center)
                    TextField("Username", text: $username)
                        .padding()
                        .frame(width:300, height:60)
                        .background(Color.white.opacity(0.08))
                        .foregroundStyle(.red)
                        .font(.subheadline)
                        .cornerRadius(10)
                        .border(.red, width:CGFloat(wrongUsername))
                        .autocorrectionDisabled(true)
                        .autocapitalization(.none)
                    TextField("Password", text: $password)
                        .padding()
                        .frame(width:300, height:60)
                        .background(Color.white.opacity(0.08))
                        .foregroundStyle(.red)
                        .font(.subheadline)
                        .cornerRadius(10)
                        .border(.red, width:CGFloat(wrongPassword))
                        .autocorrectionDisabled(true)
                        .autocapitalization(.none)
                    Button("Login"){
                        autheticateUser(username: username, password: password)
                    }
                        .frame(width:200, height:40)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.white.opacity(0.6))
                        .cornerRadius(10)
                    
//                    NavigationLink(destination: Text("Welcome @\(username), ready to finish?"), isActive: $showingLoginScreen){
//                        EmptyView()
//                    }
                    
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $showingLoginScreen){
                //Text("Welcome \(username), ready to finish?")
                //replace with some view/ next screen
                LoginPage2()
                    .navigationBarHidden(true)
            }
        }
    }
    
    func autheticateUser(username: String, password: String){
            if username == "test1"{
                wrongUsername = 0;
                if password == "test1"{
                    wrongPassword = 0
                    showingLoginScreen = true
                } else {wrongPassword = 2}
            }else{ wrongUsername = 2}
        }
    }

struct LoginPage_Previews:
    PreviewProvider{
    static var previews: some
        View{
            EmailLogin()
        }
}
