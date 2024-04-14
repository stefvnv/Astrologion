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
                                .font(.custom("Dosis", size: 14).weight(.bold))
                                .foregroundColor(Color.theme.lightLavender)
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
            .background(Color.theme.darkBlue.edgesIgnoringSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButton
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            try await viewModel.updateUserData()
                            dismiss()
                        }
                    }) {
                        Image("confirm")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .onReceive(viewModel.$user, perform: { updatedUser in
                self.user = updatedUser
            })
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    
    var backButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(Color.theme.lightLavender)
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
                .foregroundColor(Color.theme.lightLavender)
                .font(.custom("Dosis", size: 16))
            
            TextField(placeholder, text: $text)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .foregroundColor(Color.theme.lightLavender)
                .font(.custom("Dosis", size: 16))
                .background(Color.theme.lavender.opacity(0.6))
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.theme.lightLavender, lineWidth: 1)
                )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
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
                .foregroundColor(Color.theme.lightLavender)
                .font(.custom("Dosis", size: 16))

            Spacer()

            DatePicker(
                "",
                selection: $date,
                displayedComponents: displayComponents
            )
            .labelsHidden()
            .environment(\.colorScheme, .dark)
            .accentColor(Color.theme.lightLavender)
            .background(Color.clear)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .padding(.horizontal, 16)
    }
}


struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(user: .constant(dev.user))
    }
}
