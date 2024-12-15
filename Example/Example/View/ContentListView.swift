//
//  ContentListView.swift
//  Example
//
//  Created by scy on 2024/9/17.
//

import SwiftUI

struct ContentListView: View {
    @StateObject var listItemModel = ListItemViewModel()
    let item: String
//    var items: [ListItem] = listItemModel.items
    var body: some View {
        List(listItemModel.getItems()) { item in
                   HStack(spacing: 15) {
                       Image(item.icon)
                           .resizable()
                           .aspectRatio(contentMode: .fit)
                           .frame(width: 60, height: 60)
                       Text(item.title)
                           .font(.title2)
                   }
                VStack {
                    if !item.content.isEmpty {
                        Text(item.content)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            
                let images  = item.images
                VStack {
                    if images.count == 1 {
                        Image(images[0])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(10)
                            .onTapGesture {
                                print("index 0")
                            }
                    } else {
                        let columns = [GridItem(.flexible()),
                                       GridItem(.flexible()),
                                       GridItem(.flexible())]
                        LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(0..<images.count, id: \.self) { index in
                                    Image(images[index])
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        //.font(.system(size: 50))
                                        //.frame(height: 100)
                                        //.frame(maxWidth: .infinity)
                                        //.background(Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                        .tag(index)
                                        .onTapGesture {
                                            print("index \(index)")
                                        }
                                }
                        }
                    }
                }
            .padding(.vertical, 8)
            .listStyle(.plain)
            //.listRowSeparator(.hidden)
        }
        .navigationBarTitle(item, displayMode: .inline)
    }
}

#Preview {
    ContentListView(item: "")
}
