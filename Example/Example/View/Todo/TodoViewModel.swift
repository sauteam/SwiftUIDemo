//
//  TodoViewModel.swift
//  Example
//
//  Created by SAUCHYE on 9/14/24.
//

import Foundation

class TodoViewModel: ObservableObject {
    
    @Published var todoList: [TodoItem] = [] {
        didSet {
            save()
        }
    }
    
    init() {
        todoList = getTodoList()
    }
    
    func moveItem(indexSet: IndexSet, index: Int) {
        todoList.move(fromOffsets: indexSet, toOffset: index)
    }
    
    func deleteItem(indexSet: IndexSet) {
        todoList.remove(atOffsets: indexSet)
    }
    
    func addItem(_ itemModel: TodoItem) {
        todoList.append(itemModel)
    }
    
    func save() {
        UserDefaults.standard.setArray(todoList, forKey: todoListDataKey)
    }
    
    func getTodoList() -> [TodoItem] {
        let ttt: [TodoItem] = UserDefaults.standard.array(TodoItem.self, forKey: todoListDataKey) ?? []
        return ttt
    }
}
