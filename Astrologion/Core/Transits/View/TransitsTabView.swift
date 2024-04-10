import SwiftUI

struct TransitsTabView: View {
    @Binding var selectedTab: TransitTab

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { scrollViewProxy in
                HStack(spacing: 1) {
                    ForEach(TransitTab.allCases, id: \.self) { tab in
                        VStack {
                            Button(action: {
                                withAnimation {
                                    self.selectedTab = tab
                                }
                            }) {
                                Text(tab.title)
                                    .font(.custom("Dosis", size: 14))
                                    .foregroundColor(self.selectedTab == tab ? Color.theme.yellow : .gray)
                                    .fontWeight(self.selectedTab == tab ? .bold : .regular)
                                    .padding(.vertical, 8) // tap area
                            }
                            .id(tab)

                            if selectedTab == tab {
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(Color.theme.yellow)
                                    .transition(.opacity)
                            }
                        }
                        .frame(minWidth: 100, maxWidth: .infinity)
                    }
                }
                .background(Color.theme.darkBlue)
                .padding(.horizontal)
                .onChange(of: selectedTab) { newValue in
                    withAnimation {
                        scrollViewProxy.scrollTo(newValue, anchor: .leading)
                    }
                }
            }
        }
        .background(Color.theme.darkBlue)
    }
}
