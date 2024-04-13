import SwiftUI

struct DeleteAccountView: View {
    @Environment(\.dismiss) var dismiss
    var onDelete: (String) -> Void
    @State private var password: String = ""

    var body: some View {
        ZStack {
            Color.theme.darkBlue.edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Astrologion")
                    .font(.custom("PlayfairDisplay-Regular", size: 36))
                    .foregroundColor(Color.theme.yellow)
                    .padding(.top, 80)
                    .padding(.bottom, 200)
                
                VStack() {
                    Text("Enter password to confirm account deletion")
                        .font(.custom("Dosis", size: 20))
                        .foregroundColor(Color.theme.lavender)

                    SecureField("Password", text: $password)
                        .modifier(TextFieldModifier())
                    
                    Spacer()

                    Button("Confirm Deletion") {
                        onDelete(password)
                        dismiss()
                    }
                    .modifier(DeleteButtonModifier())
                }
            }
        }
    }
}

struct DeleteAccountView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAccountView(onDelete: { _ in })
    }
}
