//
//  ListView.swift
//  Example
//
//  Created by SAUCHYE on 9/6/24.
//

import SwiftUI

struct ListView: View {
    @State private var items = ["天气介绍", "进度展示", "加载动画", "DatePicker", "ButtonView", "图文混排-ContentListView", "CameraView", "HealthDataChartView"]
    @State private var selectedItem: String?
    @State private var isClicked = false
    @State private var clickedItem2 = false

    @StateObject var todoViewModel: TodoViewModel = TodoViewModel()

    var body: some View {
        NavigationView {
            Form {
                let item1: String = items.first ?? ""
                Section(header: Text(item1)) {
                    NavigationLink(destination: WeatherView(item: item1)) {
                        Text(item1)
                    }
                }
                
                let item2: String = items[1]
                Section(header: Text(item2)) {
                    Text(item2)
                        .onTapGesture {
                            clickedItem2 = true
                        }
                }.sheet(isPresented: $clickedItem2) {
                    ProgressView(item: item2)
                }
                
                let item3: String = items[2]
                Section(header: Text(item3)) {
                    NavigationLink(destination:LoadingView()) {
                        Text(item3)
                    }
                }
                
                let item4: String = items[3]
                Section(header: Text(item4)) {
                    NavigationLink(destination:PickerView()) {
                        Text(item4)
                    }
                }
                
                let item5: String = items[4]
                Section(header: Text(item5)) {
                    NavigationLink(destination:ButtonView()) {
                        Text(item5)
                    }
                }
                
                let item6: String = items[5]
                Section(header: Text(item6)) {
                    NavigationLink(destination:ContentListView(item: item6)) {
                        Text(item6)
                    }
                }
                
                let item7: String = items[6]
                Section(header: Text(item7)) {
                    NavigationLink(destination:CameraView()) {
                        Text(item7)
                    }
                }
                
                let item8 = items[7]
                Section(header: Text(item8)) {
                    NavigationLink(destination: HealthDataChartView()) {
                        Text(item8)
                    }
                }
                
            }
            
            .navigationBarTitle(Text("List"))
            .navigationBarTitleDisplayMode(.automatic)
            .navigationBarItems(trailing: Button(action: {
                isClicked = true
            }, label: {
                Text("Todo")
            }))
        }
        .sheet(isPresented: $isClicked) {
            TodoListView()
                .environmentObject(todoViewModel)
        }
        
    }
}


#Preview {
    ListView()
}
