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

                    TextField("Enter your caption..", text: $captionText, axis: .vertical)
                        .frame(height: 96)
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
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 160, height: 44)
                            .background(Color.red)
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
                        Text("Share")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 160, height: 44)
                            .background(Color.blue)
                            .cornerRadius(5)
                            .foregroundColor(.white)
                    })
                }.padding()
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
    }
}

struct UploadMediaView_Previews: PreviewProvider {
    static var previews: some View {
        UploadMediaView()
    }
}
