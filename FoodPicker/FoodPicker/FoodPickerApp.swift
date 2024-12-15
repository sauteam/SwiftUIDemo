//
//  FoodPickerApp.swift
//  FoodPicker
//
//  Created by SAUCHYE on 8/1/24.
//

import SwiftUI

@main

struct FoodPickerApp: App {
    init() {
        applyTabBarBackground()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeScreen()
        }
    }
}


extension FoodPickerApp {
    // MARK TabBar Appearance
    func applyTabBarBackground() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.backgroundColor  = .secondarySystemBackground.withAlphaComponent(0.3)
        tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterial)
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}
