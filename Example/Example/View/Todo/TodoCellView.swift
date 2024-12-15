//
//  TodoCellView.swift
//  Example
//
//  Created by SAUCHYE on 9/11/24.
//

import SwiftUI

struct TodoCellView: View {
    @Binding var todoItem: TodoItem
    var body: some View {
        HStack {
            Toggle(isOn: $todoItem.isFinish) {
                Text(todoItem.title)
                    .foregroundColor(.black)
                    .strikethrough(todoItem.isFinish)
            }
            .toggleStyle(TodoToggleStyle())
            
            Spacer()
            HStack {
                if todoItem.isMark {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }

                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(showColor(todoItem.upper))
            }
        }
    }
    
    private func showColor(_ upper: Int) -> Color {
         switch upper {
         case 0:
             return .green
         case 1:
             return .gray
         case 2:
             return .red
         default:
             return .green
         }
     }

}


struct TodoToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: configuration.isOn ? "checkmark.circle.fill": "circle")
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundColor(configuration.isOn ? .green: .gray)
            .onTapGesture {
                configuration.isOn.toggle()
            }
        configuration.label
    }
}

//#Preview {
//    TodoCellView()
//}
