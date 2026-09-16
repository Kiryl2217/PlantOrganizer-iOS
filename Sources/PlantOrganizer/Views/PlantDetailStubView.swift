import SwiftUI

public struct PlantDetailStubView: View {
    public let plant: Plant
    
    public init(plant: Plant) {
        self.plant = plant
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: plant.iconSymbol)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundStyle(Color.green)
            
            Text(plant.name)
                .font(.title)
                .fontWeight(.bold)
            
            Text(plant.scientificName)
                .font(.subheadline)
                .italic()
                .foregroundStyle(Color.secondary)
            
            Text("Детальная информация будет расширена в Лабораторной работе №2")
                .font(.footnote)
                .foregroundStyle(Color.secondary)
                .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle(plant.name)
    }
}
