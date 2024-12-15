//
//  PickerView.swift
//  Example
//
//  Created by SAUCHYE on 9/14/24.
//

import SwiftUI

struct PickerView: View {

    var body: some View {
        VStack(spacing: 10) {
            pickerStyleView()
            datePickerView()
            colorPickerView()
            setpperView()
        }
        Spacer()
        ToggleView()
        .navigationBarTitle("Picker", displayMode: .inline)
    }
}


struct pickerStyleView: View {
    @State private var selectedOption = "p2"
    // 数据源
    let options = ["p1", "p2", "p3"]

    var body: some View {
        HStack {
            Picker("Pciker", selection: $selectedOption) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Picker("Pciker2", selection: $selectedOption) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(WheelPickerStyle())
            
            Picker("Pciker3", selection: $selectedOption) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(DefaultPickerStyle())
        }
        Spacer()
    }
}


struct datePickerView: View {
    @State private var selectedDate = Date()
    var body: some View  {
        HStack {
            DatePicker(selection: $selectedDate, displayedComponents: .date) {
                Label("日期", systemImage: "clock.fill")
                    .foregroundColor(.blue)
            }
        }
        Spacer()
    }
}

struct setpperView: View {
    @State var shoes: Int = 2
    var body: some View {
        Stepper(value: $shoes, in: 2...20, step: 2) {
          Text("Pair of shoes: \(shoes/2)")
        }
        Spacer()
    }
}

struct colorPickerView: View {
    @State private var selectedColor: Color = .orange
    var body: some View {
        HStack {
            ColorPicker(selection: $selectedColor, supportsOpacity: false) {
              Label("Apple Color", systemImage: "applelogo")
              .foregroundColor(selectedColor)
            }
        }
        Spacer()
    }
}

#Preview {
    PickerView()
}
