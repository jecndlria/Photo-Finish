import SwiftUI
import SwiftData
import AWSLambda

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
                        /*
                        let lambda = AWSLambda.default()
                        let request = AWSLambdaInvocationRequest()
                        request!.functionName = "test"
                        request!.invocationType = .requestResponse // or .event if you don't need a response
                        //request!.payload = "{\"key1\": \"value1\", \"key2\": \"value2\"}".data(using: .utf8)
                        request!.payload = "Hello"
                        lambda.invoke(request!) { (response, error) in
                            if let error = error {
                                print("Error invoking Lambda function: \(error)")
                            } else if let payload = response?.payload as? [String: Any] {
                                if let string2 = payload["string2"] as? String {
                                    print(string2)
                                }
                                if let string1 = payload["string1"] as? String {
                                    print(string1)
                                }
                                print("Lambda function response: \(payload)")
                            }
                        }
                         */

                        print("Application started up!")
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
            LoginPage2()
        }
}
