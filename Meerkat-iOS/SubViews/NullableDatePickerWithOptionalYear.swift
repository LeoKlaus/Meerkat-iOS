//
//  NullableDatePickerWithOptionalYear.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 08.04.26.
//

enum Month: Int, CaseIterable {
    case january = 1
    case february = 2
    case march = 3
    case april = 4
    case may = 5
    case june = 6
    case july = 7
    case august = 8
    case september = 9
    case october = 10
    case november = 11
    case december = 12
    
    var localizedName: String {
        switch self {
        case .january:
            String(localized: "January")
        case .february:
            String(localized: "February")
        case .march:
            String(localized: "March")
        case .april:
            String(localized: "April")
        case .may:
            String(localized: "May")
        case .june:
            String(localized: "June")
        case .july:
            String(localized: "July")
        case .august:
            String(localized: "August")
        case .september:
            String(localized: "September")
        case .october:
            String(localized: "October")
        case .november:
            String(localized: "November")
        case .december:
            String(localized: "December")
        }
    }
    
    var dayRange: ClosedRange<Int> {
        switch self {
        case .january, .march, .may, .july, .august, .october, .december:
            1...31
        case .february:
            1...29
        case .april, .june, .september, .november:
            1...30
        }
    }
}

import SwiftUI

struct NullableDatePickerWithOptionalYear: View {
    
    @Binding var dateComponents: DateComponents?
    
    var bindingComponents: Binding<DateComponents>? {
        guard let dateComponents else { return nil }
        return Binding {
            dateComponents
        } set: { value in
            self.dateComponents = value
        }
    }
    
    var body: some View {
        HStack {
            if let bindingComponents, let bindingDay = Binding(bindingComponents.day), let bindingMonth = Binding(bindingComponents.month) {
                Picker("Day", selection: bindingDay) {
                    ForEach(Month(rawValue: bindingMonth.wrappedValue)?.dayRange ?? 1...31, id: \.self) { day in
                        Text(day, format: .number).tag(day)
                    }
                }
                .tint(.primary)
                .fixedSize(horizontal: true, vertical: false)
                .labelsHidden()
                
                Picker("Month", selection: bindingMonth) {
                    ForEach(Month.allCases, id: \.rawValue) { month in
                        Text(month.localizedName).tag(month.rawValue)
                    }
                }
                .tint(.primary)
                .fixedSize(horizontal: true, vertical: false)
                .labelsHidden()
                
                if let bindingYear = Binding(bindingComponents.year) {
                    Picker("Year", selection: bindingYear) {
                        ForEach(1900...2010, id: \.self) { year in
                            Text(String(year)).tag(year)
                        }
                    }
                    .tint(.primary)
                    .fixedSize(horizontal: true, vertical: false)
                    .labelsHidden()
                } else {
                    Button("Add Year") {
                        self.dateComponents?.year = 2000
                    }
                    .buttonStyle(.borderless)
                }
                
                Spacer()
                
                Button {
                    self.dateComponents = nil
                } label: {
                    Label("Remove Birthday", systemImage: "xmark.circle.fill")
                        .labelStyle(.iconOnly)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.tertiary)
            } else {
                Button("Add Birthday") {
                    self.dateComponents = DateComponents(calendar: .current, year: nil, month: 1, day: 1)
                }
                .buttonStyle(.borderless)
            }
        }
    }
}

#Preview("No Date") {
    @Previewable @State var components: DateComponents? = nil
    
    List {
        NullableDatePickerWithOptionalYear(dateComponents: $components)
    }
}

#Preview("No Year") {
    @Previewable @State var components: DateComponents? = DateComponents(calendar: .current, year: nil, month: 3, day: 12)
    
    List {
        NullableDatePickerWithOptionalYear(dateComponents: $components)
    }
}

#Preview("Full Date") {
    @Previewable @State var components: DateComponents? = DateComponents(calendar: .current, year: 1999, month: 3, day: 12)
    
    List {
        NullableDatePickerWithOptionalYear(dateComponents: $components)
    }
}
