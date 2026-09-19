import SwiftUI

public struct CareLogItemView: View {
    public let entry: CareLogEntry
    
    public init(entry: CareLogEntry) {
        self.entry = entry
    }
    
    public var body: some View {
        HStack(spacing: 14) {
            Image(systemName: entry.type.iconName)
                .font(.body)
                .foregroundStyle(Color.green)
                .frame(width: 32, height: 32)
                .background(Color.green.opacity(0.12))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.type.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                if !entry.note.isEmpty {
                    Text(entry.note)
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                }
            }
            
            Spacer()
            
            Text(entry.date, style: .date)
                .font(.caption2)
                .foregroundStyle(Color.secondary)
        }
        .padding(.vertical, 4)
    }
}
