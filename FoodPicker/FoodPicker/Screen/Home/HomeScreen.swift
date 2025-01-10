//
//  HomeScreen.swift
//  FoodPicker
//
//  Created by Jane Chao on 22/12/27.
//

import SwiftUI

struct HomeScreen: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage(.shouldUseDarkMode) var shouldUseDarkMode = false
    @State var tab: Tab = {
        let rawValue = UserDefaults.standard.string(forKey: UserDefaults.Key.startTab.rawValue) ?? ""
        return Tab(rawValue: rawValue) ?? .picker
    }()
    
    var body: some View {
        NavigationStack {
            TabView(selection: $tab) {
                ForEach(Tab.allCases)
            }.preferredColorScheme(shouldUseDarkMode ? .dark : .light)
        }
        .onAppear {
            shouldUseDarkMode = (colorScheme == .dark)
            print("Color scheme changed to1: \(colorScheme == .dark ? "Dark Mode" : "Light Mode") \(shouldUseDarkMode)")
        }
        .onChange(of: colorScheme) {newScheme, _ in
            // React to color scheme changes
            shouldUseDarkMode = (newScheme == .dark)
            print("Color scheme changed to2: \(newScheme == .dark ? "Dark Mode" : "Light Mode") \(shouldUseDarkMode)")
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
