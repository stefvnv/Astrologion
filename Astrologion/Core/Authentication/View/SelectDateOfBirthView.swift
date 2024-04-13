import SwiftUI

struct SelectDateOfBirthView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showTimeOfBirthView = false
    
    @State private var defaultDate = Calendar.current.date(from: DateComponents(year: 2000, month: 1, day: 1)) ?? Date()
    
    var body: some View {
        ZStack {
            Color.theme.darkBlue.edgesIgnoringSafeArea(.all)
            
            VStack() {
                
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(.vertical, 80)
                
                Text("Select date of birth")
                    .font(.custom("Dosis", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(Color.theme.lavender)
                
                Text("Pick your date of birth. This will determine your astrological details.")
                    .font(.custom("Dosis", size: 14))
                    .foregroundColor(Color.theme.lightLavender)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
            
                DatePicker(
                    "Select your date of birth",
                    selection: $viewModel.birthDate,
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .colorScheme(.dark)
                .padding(.horizontal)
                .environment(\.locale, Locale(identifier: "en_GB"))
                
                Spacer()
                
                Button {
                    self.showTimeOfBirthView = true
                } label: {
                    Text("Next")
                        .modifier(ButtonModifier())
                }
            }
            .padding()
            .navigationDestination(isPresented: $showTimeOfBirthView, destination: {
                SelectTimeOfBirthView()
            })
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .foregroundColor(Color.theme.lightLavender)
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
    }
}

struct SelectDateOfBirthView_Previews: PreviewProvider {
    static var previews: some View {
        SelectDateOfBirthView()
            .environmentObject(RegistrationViewModel())
    }
}
