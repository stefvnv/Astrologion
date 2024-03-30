import SwiftUI

struct UploadMediaView: View {
    @State var captionText = ""
    @State var imagePickerPresented = false
    //@Binding var tabIndex: Int
    @StateObject var viewModel = UploadPostViewModel()
    
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
                    Button(action: {
                        captionText = ""
                        viewModel.selectedImage = nil
                        viewModel.profileImage = nil
                        //tabIndex = 0
                    }, label: {
                        Text("Cancel")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 160, height: 44)
                            .background(Color.red)
                            .cornerRadius(5)
                            .foregroundColor(.white)
                    })

                    Button(action: {
                        Task {
                            try await viewModel.uploadPost(caption: captionText)
                            captionText = ""
                            //tabIndex = 0
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
