//
//  ToDoListView.swift
//  教程
//  https://space.bilibili.com/504435404/video
//  Created by SAUCHYE on 9/11/24.
//

import SwiftUI

struct TodoListView: View {
     
    @EnvironmentObject var todoViewModel: TodoViewModel
    
    @State
    var showAddTodo: Bool  = false
    @State
    var editMode = EditMode.inactive
    @State
    var isPressed: Bool = false
        
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("提醒事件"), content: {
                        ForEach($todoViewModel.todoList) { item in
                            TodoCellView(todoItem: item)
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button {
                                        item.isMark.wrappedValue.toggle()
                                    } label: {
                                        Image(systemName: "star.fill")
                                    }
                                    .tint(.yellow)
                                }
                                .onTapGesture {
                                    isPressed   = true
                                }
                        }
                        .onDelete(perform: todoViewModel.deleteItem)
                        .onMove(perform: todoViewModel.moveItem)
                        
//                        .onDelete { index in
//                            todoViewModel.removeItem(indexSet: index)
//                        }
//                        .onMove { source, destination in
//                            todoViewModel.moveItem(indexSet: source, index: destination)
//                        }
                        
                        .contextMenu {
                            Button {
                                print("点击拷贝了")
                                isPressed.toggle()
                            } label: {
                                Label("拷贝", systemImage: "doc.on.doc")
                            }
                        }
                    })
                }
                .listStyle(.plain)
                .environment(\.editMode, $editMode)
                .animation(.default, value: editMode)
                
                VStack {
                    if todoViewModel.todoList.isEmpty {
                        Image("empty")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .animation(.default, value: todoViewModel.todoList.count)
            }
            
//            ZStack {
//                Image(systemName: "plus")
//                    .font(.system(size: 35))
//                    .foregroundColor(.white)
//                    .background(.blue)
//                    .frame(width: 50, height: 50, alignment: .center)
//                    .cornerRadius(25)
//                    .shadow(radius: 5)
//                    .onTapGesture {
//                        showAddTodo = true
//                        print("onTapGesture plus")
//                    }
//            }
//            .position(x: UIScreen.main.bounds.width-60, y: 30)
//            .padding()

            .navigationTitle("待办事项")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if editMode == .inactive {
                        Menu {
                            Button {
                               showAddTodo = true
                            } label: {
                                Label {
                                    Text("添加")
                                } icon: {
                                    Image(systemName: "plus")
                                }
                            }
                            
                            Button {
                                editMode = .active
                            } label: {
                                Label {
                                    Text("编辑模式")
                                } icon: {
                                    Image(systemName: "pencil")
                                }
                            }
                        } label: {
                            Image(systemName: "text.justify")
                                .foregroundColor(.gray)
                        }
                    } else {
                        Button {
                            editMode = .inactive
                        } label: {
                            Text("完成")
                        }
                    }
                }
            }
            .sheet(isPresented: $showAddTodo) {
                AddTodoView()
            }
            .onAppear() {
                print("todoList \(todoViewModel.todoList)")
            }
//            .confirmationDialog("YES", isPresented: .constant(true)) {
//                Button {
//                    
//                } label: {
//                    Text("ActionSheet")
//                }
//            }
        }
        //.environmentObject(todoViewModel)
    }
}

//#Preview {
//    TodoListView()
//}
