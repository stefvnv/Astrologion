import SwiftUI

struct TransitsPlanetDetailView: View {
    @ObservedObject var transitsViewModel: TransitsViewModel
    var transit: Transit
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(Array(transit.aspects.enumerated()), id: \.offset) { index, aspect in
                    VStack {
                        
                        // aspect title
                        Text("\(transit.planet.rawValue) \(aspect.relationship) \(transit.natalPlanet?.rawValue ?? "Transit")")
                            .font(Font.custom("PlayfairDisplay-Regular", size: 22))
                            .foregroundColor(Color.theme.lavender)
                            .padding()
                        
                        // aspect symbol
                        Text(aspect.symbol)
                            .font(.system(size: 30))
                            .foregroundColor(Color(uiColor: aspect.darkerColor))
                            .padding(.bottom, 20)
                        
                        // aspect description
                        if let descriptionData = transitsViewModel.transitDescription.first(where: {
                            $0.transit.compare(transit.descriptionKey(for: aspect), options: .caseInsensitive) == .orderedSame
                        }) {
                            
                            // description title
                            Text(descriptionData.title)
                                .font(.custom("Dosis", size: 18))
                                .foregroundColor(Color.theme.darkBlue)
                                .padding(.horizontal)
                                .background(
                                    RoundedRectangle(cornerRadius: 26)
                                        .foregroundColor(Color(uiColor: aspect.uiColor))
                                )
                            
                            // description
                            Text(descriptionData.description)
                                .font(.custom("Dosis", size: 18))
                                .foregroundColor(Color.theme.lightLavender)
                                .padding()
                        } else {
                            Text("No description available.")
                                .font(.custom("Dosis", size: 18))
                                .foregroundColor(Color.theme.lightLavender)
                                .padding()
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(uiColor: aspect.uiColor).opacity(0.3))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                }
            }
        }
    }
}
