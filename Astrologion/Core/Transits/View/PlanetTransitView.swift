//import SwiftUI
//
//struct PlanetTransitView: View {
//    let transit: PlanetTransit
//    
//    var body: some View {
//        HStack {
//            Image(systemName: transit.planet.symbolName)
//                .frame(width: 30, height: 30)
//                .background(transit.planet.color)
//                .cornerRadius(15)
//            
//            VStack(alignment: .leading) {
//                Text("\(transit.planet.name) is in \(transit.sign)")
//                Text("in your \(transit.house.ordinal) house of \(transit.house.theme)")
//            }
//            
//            Spacer()
//        }
//        .padding(.horizontal)
//    }
//}
