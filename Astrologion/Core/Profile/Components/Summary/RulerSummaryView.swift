import SwiftUI

struct RulerSummaryView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Chart Ruler")
                .font(.custom("PlayfairDisplay-Regular", size: 20))
                .fontWeight(.bold)
                .foregroundColor(Color.theme.purple)
                .padding()
            
            if let ascendantSign = ZodiacSign(rawValue: profileViewModel.ascendantSign),
               let planet = Planet(rawValue: ascendantSign.ruler.rawValue) {
                ZStack {
                    Rectangle()
                        .fill(Color(planet.color).opacity(0.3))
                        .frame(height: 30)
                        .cornerRadius(10)
                        .overlay(
                            HStack {
                                Spacer()
                                Text(planet.rawValue)
                                    .font(.custom("Gruppo-Regular", size: 18))
                                    .textCase(.uppercase)
                                    .foregroundColor(Color(planet.darkerColor))
                                    .padding(.trailing, 120)
                            }
                        )
                    
                    Image(planet.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .offset(x: -80)
                }
            } else {
                Text("No valid ascendant sign found.")
                    .padding()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

extension Planet {
    var imageName: String {
        return self.rawValue.lowercased().replacingOccurrences(of: " ", with: "")
    }
}
