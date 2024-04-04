import SwiftUI
import Kingfisher
import PhotosUI

struct EditProfileView: View {
    @StateObject private var viewModel: EditProfileViewModel
    @Binding var user: User
    @Environment(\.dismiss) var dismiss

    init(user: Binding<User>) {
        self._user = user
        self._viewModel = StateObject(wrappedValue: EditProfileViewModel(user: user.wrappedValue))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 8) {
                    Divider()
                    
                    PhotosPicker(selection: $viewModel.selectedImage) {
                        VStack {
                            if let image = viewModel.profileImage {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 72, height: 72)
                                    .clipShape(Circle())
                                    .foregroundColor(Color(.systemGray4))
                            } else {
                                CircularProfileImageView(user: user, size: .large)
                            }
                            Text("Edit profile picture")
                                .font(.footnote)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(.vertical, 8)
                    
                    EditProfileRowView(title: "Username", placeholder: "Enter your username...", text: $viewModel.username)
                    
                    EditProfileRowView(title: "Name", placeholder: "Enter your name...", text: $viewModel.fullname)
                    
                    EditProfileRowView(title: "Bio", placeholder: "Enter your bio...", text: $viewModel.bio)
                    
                    EditProfileDatePickerView(title: "Date of Birth", date: $viewModel.birthDate, displayComponents: .date)
                    
                    EditProfileDatePickerView(title: "Time of Birth", date: $viewModel.birthTime, displayComponents: .hourAndMinute)
                    
                    
                    LocationSearchView(location: $viewModel.birthLocation)
                        .onChange(of: viewModel.birthLocation) { newLocation in
                            viewModel.geocodeLocation(newLocation) {
                                print("Geocoding completed for new location: \(newLocation)")
                            }
                        }

                    
                    Divider()
                }
                .padding(.bottom, 4)
                
                Spacer()
            }
            .onAppear{
                Task {
                    await viewModel.refreshView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.subheadline)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        Task {
                            try await viewModel.updateUserData()
                            dismiss()
                        }
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                }
            }
            .onReceive(viewModel.$user, perform: { updatedUser in
                self.user = updatedUser
            })
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct EditProfileRowView: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        
        HStack {
            Text(title)
                .padding(.leading, 8)
                .frame(width: 100, alignment: .leading)
                            
            VStack {
                TextField(placeholder, text: $text)
                
                Divider()
            }
        }
        .font(.subheadline)
        .frame(height: 36)
    }
}

struct EditProfileDatePickerView: View {
    let title: String
    @Binding var date: Date
    var displayComponents: DatePicker<Text>.Components

    var body: some View {
        HStack {
            Text(title)
                .padding(.leading, 8)
                .frame(width: 100, alignment: .leading)
            
            Spacer()

            DatePicker(
                "",
                selection: $date,
                displayedComponents: displayComponents
            )
            .datePickerStyle(CompactDatePickerStyle())
            .labelsHidden()
        }
        .font(.subheadline)
        .padding(.vertical, 8)
    }
}


struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(user: .constant(dev.user))
    }
}
