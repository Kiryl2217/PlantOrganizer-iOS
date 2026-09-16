import SwiftUI

public struct StatusBadgeView: View {
    public let isOverdue: Bool
    public let isToday: Bool
    
    public init(isOverdue: Bool, isToday: Bool) {
        self.isOverdue = isOverdue
        self.isToday = isToday
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            Image(systemName: isOverdue ? "exclamationmark.triangle.fill" : (isToday ? "clock.fill" : "checkmark.circle.fill"))
            Text(isOverdue ? "Просрочен полив" : (isToday ? "Полить сегодня" : "В норме"))
                .font(.caption2)
                .fontWeight(.bold)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(isOverdue ? Color.red.opacity(0.15) : (isToday ? Color.orange.opacity(0.15) : Color.green.opacity(0.15)))
        .foregroundStyle(isOverdue ? Color.red : (isToday ? Color.orange : Color.green))
        .clipShape(Capsule())
    }
}
