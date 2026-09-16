import SwiftUI

public struct PlantCardView: View {
    public let plant: Plant
    
    public init(plant: Plant) {
        self.plant = plant
    }
    
    private var cardBorderColor: Color {
        if plant.isWateringOverdue {
            return Color.red.opacity(0.6)
        } else if plant.isWateringToday {
            return Color.orange.opacity(0.5)
        } else {
            return Color.clear
        }
    }
    
    private var cardBackgroundColor: Color {
        if plant.isWateringOverdue {
            return Color.red.opacity(0.06)
        } else {
            return Color(.secondarySystemBackground)
        }
    }
    
    public var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(plant.isWateringOverdue ? Color.red.opacity(0.15) : Color.green.opacity(0.15))
                    .frame(width: 54, height: 54)
                
                Image(systemName: plant.iconSymbol)
                    .font(.title2)
                    .foregroundStyle(plant.isWateringOverdue ? Color.red : Color.green)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(plant.name)
                    .font(.headline)
                    .foregroundStyle(Color.primary)
                
                Text(plant.scientificName)
                    .font(.caption)
                    .italic()
                    .foregroundStyle(Color.secondary)
                
                HStack(spacing: 6) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.caption2)
                    Text(plant.room)
                        .font(.caption2)
                }
                .foregroundStyle(Color.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 6) {
                StatusBadgeView(isOverdue: plant.isWateringOverdue, isToday: plant.isWateringToday)
                
                Text(plant.nextWateringDate, style: .date)
                    .font(.caption2)
                    .foregroundStyle(Color.secondary)
            }
        }
        .padding()
        .background(cardBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(cardBorderColor, lineWidth: 1.5)
        )
    }
}
