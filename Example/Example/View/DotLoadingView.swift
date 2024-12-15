//
//  DotLoadingView.swift
//  Example
//
//  Created by SAUCHYE on 9/6/24.
//

import SwiftUI

struct DotLoadingView: View {
    @Environment(\.presentationMode) var mode
    @Binding var isLoading: Bool
    var index: Int
    var body: some View {
        Circle()
            .frame(width: 30, height: 30)
            .foregroundColor(.green)
            .scaleEffect(isLoading ? 0: 1)
            .animation(.linear(duration: 0.8)
                .repeatForever(autoreverses: true)
                .delay(0.2*Double(index)), value: isLoading)
        
            .navigationBarTitle("Loading...", displayMode: .inline)
            .navigationBarBackButtonHidden()
            .navigationBarItems(leading: Button(action: {
                mode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.left")
                    .font(.title)
                    .foregroundColor(.black)
            }))
    }
}


struct LoadingView: View {
    @State var isLoading: Bool = false
    var body: some View {
        HStack {
            DotLoadingView(isLoading: $isLoading, index: 1)
            DotLoadingView(isLoading: $isLoading, index: 2)
            DotLoadingView(isLoading: $isLoading, index: 3)
            DotLoadingView(isLoading: $isLoading, index: 4)
            DotLoadingView(isLoading: $isLoading, index: 5)
        }
        .onAppear() {
            isLoading = true
        }
    }
}

