//
//  WeatherView.swift
//  Weather-SwiftUI
//
//  Created by SAUCHYE on 9/5/24.
//

import SwiftUI

struct WeatherView: View {
    @Environment(\.presentationMode) var mode

    @State var degree: Int  = 35
    @State var isDark: Bool = false
    let item: String

    var body: some View {
        ZStack {
            LinearGradient(colors: isDark ? [.black, .gray]: [.blue, .white], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            VStack {
                Text("广州")
                    .font(.system(size: 45))
                    .foregroundStyle(.white)
                    .onTapGesture {
                        isDark.toggle()
                        print("\(isDark) true is dark or not dark")
                    }
                
                Image(systemName: "cloud.sun.fill")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                Text("\(degree)°")
                    .font(.system(size: 40))
                    .foregroundStyle(.white)
                    .onTapGesture {
                        degree += 1
                    }
                
                Spacer().frame(height:40)
                HStack(spacing: 20) {
                    VStack {
                        DayForecast(day: "周一", weatherIcon: "cloud.sun.fill", temp: 30)
                    }
                    
                    VStack {
                        DayForecast(day: "周二", weatherIcon: "cloud.rain.fill", temp: 31)
                    }

                    VStack {
                        DayForecast(day: "周三", weatherIcon: "cloud.sun.fill", temp: 33)
                    }
                    VStack {
                        DayForecast(day: "周四", weatherIcon: "cloud.sun.fill", temp: 25)
                    }

                    VStack {
                        DayForecast(day: "周五", weatherIcon: "cloud.sun.fill", temp: 29)
                    }

                    VStack {
                        DayForecast(day: "周六", weatherIcon: "cloud.sun.fill", temp: 27)
                    }
                    VStack {
                        DayForecast(day: "周日", weatherIcon: "cloud.sun.fill", temp: 33)
                    }
                }
                
                .padding()
                                
                Spacer().frame(height: 30)
                Button {
                    degree -= 1
                } label: {
                    Text("一键清除")
                        .frame(width: 200, height: 40, alignment: .center)
                        .bold()
                        .font(.title3)
                        .background(.white)
                        .cornerRadius(20)
                }
            }
        }
        .navigationBarTitle(item, displayMode: .inline)
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: Button(action: {
            mode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "chevron.left")
                .font(.title2)
                .foregroundColor(.white)
        }))
    }
}

struct DayForecast: View {
    var day: String
    var weatherIcon: String
    var temp: Int
    var body: some View {
        Text(day)
            .font(.system(size: 12))
            .foregroundStyle(.white)
        Image(systemName: weatherIcon)
            .renderingMode(.original)
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
        Text("\(temp)°")
            .font(.system(size: 20))
            .foregroundStyle(.white)
    }
}

//#Preview {
//    WeatherView(item: "")
//}
