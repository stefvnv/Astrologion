import SwiftUI

struct BarView: View {
    var summaries: [Summary]
    let totalWidth = UIScreen.main.bounds.width - 32

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                ForEach(summaries, id: \.type) { summary in
                    ZStack {
                        Color(summary.color)
                            .frame(width: totalWidth * summary.percentage, height: 30)
                        summary.symbol
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .position(x: totalWidth * summary.percentage / 2, y: 15)
                    }
                }
            }
            .cornerRadius(10)
            
            HStack(spacing: 0) {
                ForEach(summaries, id: \.type) { summary in
                    VStack {
                        Text(summary.type)
                            .font(.custom("Dosis", size: 12))
                            .foregroundColor(Color.theme.darkBlue)
                            .frame(width: totalWidth * summary.percentage, alignment: .center)
                        Text("\(Int(summary.percentage * 100))%")
                            .font(.custom("Dosis", size: 12))
                            .foregroundColor(Color.theme.darkBlue)
                            .frame(width: totalWidth * summary.percentage, alignment: .center)
                    }
                    .background(Color.clear)
                }
            }
        }
    }
}
