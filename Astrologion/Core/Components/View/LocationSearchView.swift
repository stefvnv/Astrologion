import SwiftUI

struct LocationSearchView: View {
    @Binding var location: String
    @State private var searchQuery = ""
    @StateObject private var completer = LocationSearchCompleter()

    var body: some View {
        VStack {
            TextField("Enter a city", text: $searchQuery)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: searchQuery) { newValue in
                    completer.updateSearchQuery(newValue)
                }

            List(completer.searchResults, id: \.self) { result in
                Button(action: {
                    self.location = result.title
                    self.searchQuery = result.title
                }) {
                    Text(result.title)
                }
            }
        }
    }
}
