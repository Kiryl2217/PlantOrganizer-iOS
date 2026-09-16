import SwiftUI

public struct CalendarStripView: View {
    @Binding public var selectedDate: Date
    private let calendar = Calendar.current
    
    public init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
    }
    
    private var weekDates: [Date] {
        let today = calendar.startOfDay(for: Date())
        return (-2...4).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: today)
        }
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Календарь процедур")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(weekDates, id: \.self) { date in
                        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
                        
                        VStack(spacing: 6) {
                            Text(date.formatted(.dateTime.weekday(.short)))
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .textCase(.uppercase)
                            
                            Text(date.formatted(.dateTime.day()))
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .frame(width: 50, height: 65)
                        .foregroundStyle(isSelected ? Color.white : Color.primary)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(isSelected ? Color.green : Color(.secondarySystemBackground))
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3)) {
                                selectedDate = date
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
