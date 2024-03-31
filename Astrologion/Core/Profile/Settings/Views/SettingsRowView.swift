import SwiftUI

struct SettingsRowView: View {
    let model: SettingsItemModel
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: model.imageName)
                .foregroundColor(model == .deleteAccount ? .red : .primary)
                .imageScale(.medium)
            
            Text(model.title)
                .foregroundColor(model == .deleteAccount ? .red : .primary)
                .font(.subheadline)
        }
    }
}
