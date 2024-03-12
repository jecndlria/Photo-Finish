import SwiftUI
import SwiftData
import AWSCore
import AWSLambda


struct CreateAccount: View {
    
    
    @State private var username = ""
    @State private var password = ""
    @State private var password2 = ""
    @State private var showingLoginScreen = false
    @State private var passwordsNoMatch = 0
    func createUser(username: String, password: String, password2: String){
        if password == password2{
            passwordsNoMatch = 0
            let lambda = AWSLambda.default()
            let request = AWSLambdaInvocationRequest()
            request!.functionName = "test"
            request!.invocationType = .requestResponse
            request!.payload = "{\"username\": \"\(username)\", \"password\": \"\(password)\"}".data(using: .utf8)
            lambda.invoke(request!) { (response, error) in
                        if let error = error {
                            print("Error invoking Lambda function: \(error)")
                        } else if let payload = response?.payload {
                            // Handle the response payload here
                            print("Lambda function response: \(payload)")
                        }
                    }
            
            showingLoginScreen = true
        }else{
            passwordsNoMatch = 2
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
                    createUser(username: username, password: password, password2: password2)
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
