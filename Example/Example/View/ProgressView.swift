//
//  ProgressView.swift
//  Example
//
//  Created by SAUCHYE on 9/11/24.
//

import SwiftUI

struct ProgressView: View {
    @Environment(\.presentationMode) var mode
    @ObservedObject var combineStore = CombineStore()
    //@State var progress: Float = 0.1
    var width: CGFloat = 300.0
    let item: String
    var body: some View {
        NavigationView {
            ZStack {
                Circle()
                    .stroke(.gray.opacity(0.3), lineWidth: 25)
                    .frame(width: width, height: width)
                
                Circle()
                    .trim(from: 0, to: combineStore.progress)
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .foregroundColor(.green)
                    .frame(width: width, height: width)
                
                VStack() {
                    Text("进度:\(Int(combineStore.progress * 100))%")
                        .foregroundColor(.gray.opacity(0.7))
                        .font(.title2)
                        .fontWeight(.bold)

                    Button {
                        withAnimation(Animation.spring(response: 1, dampingFraction: 0.6, blendDuration: 0)) {
                            combineStore.progress += 0.1
                            if combineStore.progress >= 1.0 {
                                combineStore.progress = 1.0
                            }
                        }
                        print("progress: \(combineStore.progress)")
                    } label: {
                        Text("点击增加进度")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    
                    Button() {
                        print("progress: \(combineStore.progress)")
                        if combineStore.progress <= 0.1 {
                            return
                        }
                        
                        withAnimation(Animation.spring(response: 1, dampingFraction: 0.6, blendDuration: 0)) {
                            combineStore.progress = 0.1
                        }
                    } label: {
                        Text("重置")
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                Slider(value: $combineStore.progress, in: 0...1, label: {
                    EmptyView()
                }, minimumValueLabel: {
                    Text("最小进度")
                }, maximumValueLabel: {
                    Text("最大进度")
                })
                .offset(y: 200)
            }
            .navigationBarTitle(item, displayMode: .inline)
            .navigationBarBackButtonHidden()
            .navigationBarItems(leading: Button(action: {
                mode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.black)
            }))
        }
        .padding()
        
    }
}

//#Preview {
//    ProgressView()
//}
