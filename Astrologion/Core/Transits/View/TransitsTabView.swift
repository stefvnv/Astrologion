import SwiftUI

struct TransitsTabView: View {
    @Binding var selectedTab: TransitTab

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { scrollViewProxy in
                HStack(spacing: 20) {
                    ForEach(TransitTab.allCases, id: \.self) { tab in
                        VStack {
                            Button(action: {
                                withAnimation {
                                    self.selectedTab = tab
                                }
                            }) {
                                Text(tab.title)
                                    .font(.system(size: 16))
                                    .foregroundColor(self.selectedTab == tab ? .black : .gray)
                                    .fontWeight(self.selectedTab == tab ? .bold : .regular)
                                    .padding(.vertical, 8)
                            }
                            .id(tab)

                            if selectedTab == tab {
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(.black)
                                    .transition(.opacity)
                            }
                        }
                        .frame(minWidth: 100, maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                .onChange(of: selectedTab) { newValue in
                    withAnimation {
                        scrollViewProxy.scrollTo(newValue, anchor: .leading)
                    }
                }
            }
        }
        .background(Color.white)
    }
}
