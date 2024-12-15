//
//  AddTodoView.swift
//  Example
//
//  Created by SAUCHYE on 9/11/24.
//

import SwiftUI

struct AddTodoView: View {
    @State var title: String = ""
    @State var selectedPriority: Priority = .normal
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var todoListModel: TodoViewModel
    var body: some View {
        VStack {
            HStack {
                Text("新建代办")
                    .font(.title.bold())
                Spacer()
            }
            .padding()
            .padding(.horizontal)
            TextField("请输入代办任务", text: $title)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            HStack {
                Text("优先级")
                    .font(.body)
                Spacer()
            }
            .padding(.top)
            .padding(.horizontal)
            
            Picker(selection: $selectedPriority) {
                ForEach(Priority.allCases, id:\.self) { p in
                    Text(p.text)
                }
            } label: {
                
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            Button {
                withAnimation(.spring()) {
                    addNewTodo()
                    presentationMode.wrappedValue.dismiss()
                }
            } label: {
                Text("保存")
                    .font(.callout.bold())
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.purple)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .padding()
        }
        .padding()
        .presentationDetents([.fraction(0.4), .medium])
        .onAppear() {
            
        }
    }
    
    
    func addNewTodo()  {
        if title.isEmpty {
            return
        }
        
        let item = TodoItem(title: title, isFinish: false, isMark: false, upper: TodoItem.upperIndex(selectedPriority))
        if selectedPriority == .high {
            todoListModel.todoList.insert(item, at: 0)
        } else {
            todoListModel.addItem(item)
        }
        let tt = todoListModel.getTodoList()
        print("ttt \(tt)")
    }
}

//#Preview {
//    EditTodoView(todoList: .constant([]))
//}
