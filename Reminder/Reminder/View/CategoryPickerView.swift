//
//  CategoryPickerView.swift
//  Reminder
//
//  Created by scy on 2024/12/27.
//

import SwiftUI

struct CategoryPickerView: View {
    @Binding var selectedCategory: ReminderCategory?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                CategoryButton(title: "全部", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }
                
                ForEach(ReminderCategory.allCases, id: \.self) { category in
                    CategoryButton(title: category.rawValue,
                                 isSelected: selectedCategory == category) {
                        selectedCategory = category
                    }
                }
            }
            .padding()
        }
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}
