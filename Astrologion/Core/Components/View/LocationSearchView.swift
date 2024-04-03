import SwiftUI

struct LocationSearchView: View {
    @Binding var location: String
    @State private var searchQuery: String = ""
    @State private var isShowingResults: Bool = false
    @StateObject private var completer = LocationSearchCompleter()

    var body: some View {
        VStack {
            TextField("", text: $searchQuery, prompt: Text(location.isEmpty ? "Enter a city" : location))
                .modifier(TextFieldModifier())
                .onTapGesture {
                    self.isShowingResults = true
                }
                .onChange(of: searchQuery) { newValue in
                    completer.updateSearchQuery(newValue)
                    self.isShowingResults = true
                }

            if isShowingResults {
                List(completer.searchResults, id: \.self) { result in
                    Button(action: {
                        self.location = result.title
                        self.searchQuery = result.title
                        self.isShowingResults = false // Hide the list when a city is selected
                    }) {
                        Text(result.title)
                    }
                }
            }
        }
    }
}
