//
//  ListItem.swift
//  Example
//
//  Created by scy on 2024/9/17.
//

import Foundation

class ListItemViewModel: ObservableObject {
    
//    @Published var items: [ListItem]
    
//    init() {
//        self.items = getItems()
//    }
    
    func getItems() -> [ListItem] {
        let item = [
            ListItem(icon: "dinner", title: "收藏", content: "您最喜爱的内容，秋天真美好啊啊啊啊啊啊啊啊啊啊,您最喜爱的内容，秋天真美好啊啊啊啊啊啊啊啊啊啊,您最喜爱的内容，秋天真美好啊啊啊啊啊啊啊啊啊啊,您最喜爱的内容，秋天真美好啊啊啊啊啊啊啊啊啊啊,您最喜爱的内容，秋天真美好啊啊啊啊啊啊啊啊啊啊,您最喜爱的内容，秋天真美好啊啊啊啊啊啊啊啊啊啊,您最喜爱的内容，秋天真美好啊啊啊啊啊啊啊啊啊啊", images: ["dinner"]),
            ListItem(icon: "dinner", title: "喜欢", content: "您点赞的内容", images: []),
            ListItem(icon: "dinner", title: "个人", content: "", images: ["dinner", "dinner", "dinner", "dinner", "dinner", "dinner"]),
            ListItem(icon: "dinner", title: "收藏", content: "您最喜爱的内容，秋天真美好啊啊啊啊啊啊啊啊啊啊,您最喜爱的内容，秋天真美好啊啊啊啊啊啊啊啊啊啊,您最喜爱的内容，秋天真美好啊啊啊啊啊啊啊啊啊啊,您最喜爱的内容，秋天真美好啊啊啊啊啊啊啊啊啊啊,您最喜爱的内容，秋天真美好啊啊啊啊啊啊啊啊啊啊,您最喜爱的内容，秋天真美好啊啊啊啊啊啊啊啊啊啊,您最喜爱的内容，秋天真美好啊啊啊啊啊啊啊啊啊啊", images: ["dinner"]),
            ListItem(icon: "dinner", title: "个人", content: "秋天真美好啊啊啊啊啊啊啊啊啊啊", images: ["dinner", "dinner", "dinner", "dinner", "dinner", "dinner"]),
            ListItem(icon: "dinner", title: "个人", content: "", images: ["dinner", "dinner"]),
            ListItem(icon: "dinner", title: "个人", content: "您最喜爱的内容，秋天真美好啊啊啊啊啊啊啊啊啊啊,您最喜爱的内容", images: ["dinner", "dinner", "dinner", "dinner"]),
            ListItem(icon: "dinner", title: "个人", content: "您最喜爱的内容，秋天真美好啊啊啊啊啊啊啊啊啊啊,您最喜爱的内容，秋天真美好啊啊啊啊啊啊啊啊啊啊,您最喜爱的内容，秋天真美好啊啊啊啊啊啊啊啊啊啊,您最喜爱的内容，秋天真美好啊啊啊啊啊啊啊啊啊啊,您最喜爱的内容，秋天真美好啊啊啊啊啊啊啊啊啊啊,您最喜爱的内容，秋天真美好啊啊啊啊啊啊啊啊啊啊,您最喜爱的内容，秋天真美好啊啊啊啊啊啊啊啊啊啊", images: ["dinner", "dinner", "dinner", "dinner", "dinner", "dinner", "dinner", "dinner", "dinner"]),
            ]
        return item
    }
}

struct ListItem: Identifiable, Codable {
    var id = UUID()
    var icon: String
    var title: String
    var content: String
    var images: [String]
}

