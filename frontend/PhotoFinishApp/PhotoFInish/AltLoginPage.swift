import SwiftUI
import SwiftData

struct AltLoginPage: View {
    var body: some View{
        ZStack{
            Color.black
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("📸")
                    .font(.system(size: 100))
                Text("Photo Finish")
                    .foregroundStyle(.white)
                    .font(.title)
                    .bold()
                Text("💥")
                    .font(.system(size: 100))
            }
        }
    }
}

struct File_Previews:
    PreviewProvider{
    static var previews: some
        View{
            AltLoginPage()
        }
}
