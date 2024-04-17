import SwiftUI

struct CommentsView: View {
    @State private var commentText = ""
    @StateObject var viewModel: CommentViewModel
    
    init(post: Post) {
        self._viewModel = StateObject(wrappedValue: CommentViewModel(post: post))
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 32) {
                    ForEach(viewModel.comments) { comment in
                        CommentCell(comment: comment)
                    }
                }
            }.padding(.top)
            
            Divider()
                .padding(.bottom)
            
            CustomInputView(inputText: $commentText,
                             placeholder: "Add a comment...",
                             buttonTitle: "Post",
                             action: uploadComment)
        }
        .navigationTitle("Comments")
        .toolbar(.hidden, for: .tabBar)
        .background(Color.theme.darkBlue)
    }
    
    func uploadComment() {
        Task {
            try await viewModel.uploadComment(commentText: commentText)
            commentText = ""
        }
    }
}
