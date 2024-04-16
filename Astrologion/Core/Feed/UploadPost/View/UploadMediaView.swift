import SwiftUI

struct UploadMediaView: View {
    @State var captionText = ""
    @State var imagePickerPresented = false
    @StateObject var viewModel = UploadPostViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            if let image = viewModel.profileImage {
                HStack {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 96, height: 96)
                        .clipped()

                    ZStack(alignment: .leading) {
                        if captionText.isEmpty {
                            Text("Write a caption...")
                                .foregroundColor(Color.white.opacity(0.3))
                                .padding(.leading, 10)
                                .font(.custom("Dosis", size: 16))
                        }
                        TextField("", text: $captionText, axis: .vertical)
                            .frame(height: 96)
                            .font(.custom("Dosis", size: 16))
                            .foregroundColor(Color.theme.lightLavender)
                            .padding(.horizontal, 10)
                            .background(Color.theme.lightLavender.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
                
                HStack(spacing: 16) {
                    // cancel
                    Button(action: {
                        captionText = ""
                        viewModel.selectedImage = nil
                        viewModel.profileImage = nil
                        dismiss()
                    }, label: {
                        Text("Cancel")
                            .font(.custom("Dosis", size: 16)).fontWeight(.semibold)
                            .frame(width: 160, height: 44)
                            .background(Color.red.opacity(0.4))
                            .cornerRadius(5)
                            .foregroundColor(.white)
                    })

                    // share
                    Button(action: {
                        Task {
                            try await viewModel.uploadPost(caption: captionText)
                            captionText = ""
                            dismiss()
                        }
                    }, label: {
                        Text("Post")
                            .font(.custom("Dosis", size: 16)).fontWeight(.semibold)
                            .frame(width: 160, height: 44)
                            .background(Color.blue.opacity(0.4))
                            .cornerRadius(5)
                            .foregroundColor(.white)
                    })
                }
                .padding()
            }
            Spacer()
        }
        .padding()
        .photosPicker(isPresented: $imagePickerPresented, selection: $viewModel.selectedImage)
        .onAppear {
            self.imagePickerPresented.toggle()
        }
        .onDisappear {
            viewModel.selectedImage = nil
            viewModel.profileImage = nil
        }
        .background(Color.theme.darkBlue)
    }
}

struct UploadMediaView_Previews: PreviewProvider {
    static var previews: some View {
        UploadMediaView()
    }
}
