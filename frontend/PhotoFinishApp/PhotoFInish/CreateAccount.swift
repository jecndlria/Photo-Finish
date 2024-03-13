import SwiftUI
import SwiftData
import AWSCore
import AWSLambda




struct CreateAccount: View {
    
    
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var password2 = ""
    @State private var showingLoginScreen = false
    @State private var passwordsNoMatch = 0
    @State private var usernameBad = 0;
    @State private var printedOutput = ""
    struct RedirectedOutputStream: TextOutputStream {
            var target: CreateAccount

            mutating func write(_ string: String) {
                target.printedOutput.append(string)
            }
        }
    func createUser(username: String, email: String, password: String){
        let lambda = AWSLambda.default()
        let request = AWSLambdaInvocationRequest()
        request!.functionName = "create_account"
        request!.invocationType = .requestResponse
        request!.payload = "{\"username\": \"\(username)\", \"name\": \"\(username)\", \"email\": \"\(email)\", \"password\": \"\(password)\"}".data(using: .utf8)
        lambda.invoke(request!) { (response, error) in
                    if let error = error {
                        print("Error invoking Lambda function: \(error)")
                    } else if let payload = response?.payload {
                        //as? Data, let payloadString = String(data: payload, encoding: .utf8)
                        // Handle the response payload here
                        print("Lambda function response: \(payload)")
                        var outputStream = RedirectedOutputStream(target: self)
                        print("Lambda function response: \(payload)", to: &outputStream)
                        print("Captured output: \(printedOutput)")
                        if printedOutput.contains("200") {
                            printedOutput = ""
                            showingLoginScreen = true
                        }else if printedOutput.contains("500"){
                            usernameBad = 2
                            printedOutput = ""
                        }else{
                            passwordsNoMatch = 2
                            printedOutput = ""
                        }
                    }
                }
    }
    var body: some View{
        ZStack{
            Color.black
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Enter your email and a password")
                    .foregroundStyle(.white)
                    .bold()
                    .font(.system(size: 25))
                    .multilineTextAlignment(.center)
                TextField("Username", text: $username)
                    .padding()
                    .frame(width:250, height:40)
                    .background(Color.white.opacity(0.08))
                    .foregroundStyle(.red)
                    .font(.subheadline)
                    .cornerRadius(10)
                    .autocorrectionDisabled(true)
                    .autocapitalization(.none)
                    .border(.red, width:CGFloat(usernameBad))
                TextField("Email", text: $email)
                    .padding()
                    .frame(width:250, height:40)
                    .background(Color.white.opacity(0.08))
                    .foregroundStyle(.red)
                    .font(.subheadline)
                    .cornerRadius(10)
                    .autocorrectionDisabled(true)
                    .autocapitalization(.none)
                    .border(.red, width:CGFloat(passwordsNoMatch))
                SecureField("Password", text: $password)
                    .padding()
                    .frame(width:250, height:40)
                    .background(Color.white.opacity(0.08))
                    .foregroundStyle(.red)
                    .font(.subheadline)
                    .cornerRadius(10)
                    .autocorrectionDisabled(true)
                    .autocapitalization(.none)
                    .border(.red, width:CGFloat(passwordsNoMatch))
                SecureField("Confirm Password", text: $password2)
                    .padding()
                    .frame(width:250, height:40)
                    .background(Color.white.opacity(0.08))
                    .foregroundStyle(.red)
                    .font(.subheadline)
                    .cornerRadius(10)
                    .autocorrectionDisabled(true)
                    .autocapitalization(.none)
                    .border(.red, width:CGFloat(passwordsNoMatch))
                Button("Create Account"){
                    if (password == password2) && (username != "") && (email != ""){
                        passwordsNoMatch = 0;
                        createUser(username: username, email: email, password: password)
                        
                    }else if password != password2{
                        passwordsNoMatch = 2;
                    }
                }
                    .frame(width:200, height:30)
                    .background(Color.blue.opacity(0.2))
                    .foregroundColor(.white.opacity(0.6))
                    .cornerRadius(10)

            }
        }
        .navigationDestination(isPresented: $showingLoginScreen){
            //Text("Welcome \(username), ready to finish?")
            //replace with some view/ next screen
            EmailLogin()
        }
    }
}

struct CreateAccount_Previews:
    PreviewProvider{
    static var previews: some
        View{
            CreateAccount()
        }
}
