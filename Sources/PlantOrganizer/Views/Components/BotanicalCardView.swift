import SwiftUI

public struct BotanicalCardView: View {
    public let icon: String
    public let title: String
    public let description: String
    public let iconColor: Color
    
    public init(icon: String, title: String, description: String, iconColor: Color) {
        self.icon = icon
        self.title = title
        self.description = description
        self.iconColor = iconColor
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(iconColor)
                .frame(width: 36, height: 36)
                .background(iconColor.opacity(0.12))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.secondary)
                    .textCase(.uppercase)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(Color.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
