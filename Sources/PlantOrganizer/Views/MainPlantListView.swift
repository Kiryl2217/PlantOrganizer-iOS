import SwiftUI

public struct MainPlantListView: View {
    @State private var viewModel = PlantListViewModel()
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    CalendarStripView(selectedDate: $viewModel.selectedDate)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("План на \(viewModel.selectedDate.formatted(.dateTime.day().month()))")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.secondary)
                            .padding(.horizontal)
                        
                        if viewModel.tasksForSelectedDate.isEmpty {
                            Text("Нет запланированных процедур на этот день.")
                                .font(.footnote)
                                .foregroundStyle(Color.secondary)
                                .padding(.horizontal)
                        } else {
                            ForEach(viewModel.tasksForSelectedDate) { task in
                                HStack {
                                    Image(systemName: task.type.iconName)
                                        .foregroundStyle(Color.green)
                                    Text("\(task.type.rawValue): \(task.plantName)")
                                        .font(.subheadline)
                                        .strikethrough(task.isCompleted, color: .secondary)
                                    Spacer()
                                    Button {
                                        viewModel.toggleTaskCompletion(taskId: task.id)
                                    } label: {
                                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                            .foregroundStyle(task.isCompleted ? Color.green : Color.secondary)
                                    }
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Мои растения")
                                .font(.headline)
                            Spacer()
                            Text("\(viewModel.filteredPlants.count) шт.")
                                .font(.subheadline)
                                .foregroundStyle(Color.secondary)
                        }
                        .padding(.horizontal)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.filteredPlants) { plant in
                                NavigationLink(value: plant.id) {
                                    PlantCardView(plant: plant)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemBackground))
            .navigationTitle("Мой Сад")
            .searchable(text: $viewModel.searchText, prompt: "Поиск растения или комнаты...")
            .onChange(of: viewModel.searchText) { _, _ in
                viewModel.updateFilteredPlants()
            }
            .navigationDestination(for: UUID.self) { plantId in
                if let selectedPlant = viewModel.plants.first(where: { $0.id == plantId }) {
                    PlantDetailStubView(plant: selectedPlant)
                }
            }
        }
    }
}
