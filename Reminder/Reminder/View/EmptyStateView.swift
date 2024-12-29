//
//  EmptyStateView.swift
//  Reminder
//
//  Created by scy on 2024/12/27.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "bell.badge")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("没有提醒事项")
                .font(.title2)
                .foregroundColor(.gray)
            
            Text("点击右上角的 + 按钮添加新的提醒")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
    }
}
