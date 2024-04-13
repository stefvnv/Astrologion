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
                .font(.custom("Dosis", size: 16))
                .foregroundColor(Color.theme.lightLavender)
                .onTapGesture {
                    self.isShowingResults = true
                }
                .onChange(of: searchQuery) { newValue in
                    completer.updateSearchQuery(newValue)
                    self.isShowingResults = true
                }
                .padding()
                .background(Color.theme.darkBlue)
                .cornerRadius(5)

            if isShowingResults {
                List(completer.searchResults, id: \.self) { result in
                    Button(action: {
                        self.location = result.title
                        self.searchQuery = result.title
                        self.isShowingResults = false
                    }) {
                        Text(result.title)
                            .font(.custom("Dosis", size: 14))
                            .foregroundColor(Color.theme.lightLavender)
                    }
                    .listRowBackground(Color.theme.darkBlue)
                    .padding(.horizontal, 25)
                }
                .listStyle(PlainListStyle())
                .background(Color.theme.darkBlue)
            }
        }
        .background(Color.theme.darkBlue)
        .onAppear {
            UITableView.appearance().backgroundColor = UIColor(Color.theme.darkBlue)
            UITableViewCell.appearance().backgroundColor = UIColor(Color.theme.darkBlue)
            UITableView.appearance().separatorColor = UIColor(Color.theme.darkBlue)
        }
        .onDisappear {
            UITableView.appearance().backgroundColor = nil
            UITableViewCell.appearance().backgroundColor = nil
            UITableView.appearance().separatorColor = nil
        }
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView(location: .constant(""))
            .environmentObject(RegistrationViewModel())
    }
}
