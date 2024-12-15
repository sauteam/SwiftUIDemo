//
//  ButtonView.swift
//  Example
//
//  Created by SAUCHYE on 9/15/24.
//

import SwiftUI

struct ButtonView: View {
    var body: some View {
        Form {
            HStack {
                Button {
                    print("渐变按钮")
                } label: {
                    Text("渐变按钮")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .background(
                            LinearGradient(colors: [.orange, .yellow], startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(width: 200, height: 40)
                        .cornerRadius(10)
                }
            }
            
            Button {
                print("一个❤")
            } label: {
                Circle()
                    .fill(Color.white)
                    .frame(width: 60,height: 60)
                    .shadow(radius: 10)
                    .overlay(
                        Image(systemName: "heart.fill")
                            .font(.title)
                            .foregroundColor(Color.red)
                    )
            }
            LinkerView()
            Spacer()
        }
        //.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}


struct LinkerView: View {
    private let appleUrl: URL = .init(string: "http://apple.com")!
    var body: some View {
        LabeledContent("字符串重构") {
            Link("apple.com" ,destination: appleUrl)
        }
        
        LabeledContent("View构建") {
            Link(destination: appleUrl) {
                Text("apple") //("apple", systemImage: "applelogo")
                    .foregroundColor(.blue)
            }
        }
        
        LabeledContent("分享图片") {
            ShareLink(
                item: Image("parrot_small"),
                preview: SharePreview (
                    "分享文字",
                    image: Image("parrot_small")
                )
            )
        }
        
    }
}

struct backgroundColorView: View {
    @State var backgroundColor: Color = .mint
    @State var title: String = "未点击"
    var body: some View {
        backgroundColor
            .edgesIgnoringSafeArea(.all)
        Button {
            backgroundColor = Color.yellow
            title = "已完成"
        } label: {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color.white)
                .padding()
                .padding(.horizontal)
                .background(Color.black)
                .cornerRadius(10)
        }
    }
}

#Preview {
    ButtonView()
}
