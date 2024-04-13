import SwiftUI

struct SettingsRowView: View {
    let model: SettingsItemModel
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: model.imageName)
                .foregroundColor(model == .deleteAccount ? .red : Color.theme.lightLavender)
                .imageScale(.medium)
            
            Text(model.title)
                .foregroundColor(model == .deleteAccount ? .red : Color.theme.lightLavender)
                .font(Font.custom("Dosis", size: 16))
        }
    }
    
}
