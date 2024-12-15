//
//  CatImageApp.swift
//  CatImage
//
//  Created by SAUCHYE on 7/26/24.
//

import SwiftUI

@main
struct CatImageApp: App {
    init() {
        applyTabBarBackground()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .environmentObject(CatAPIManager.shared)
        }
    }
}

extension CatImageApp {
    func applyTabBarBackground() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.backgroundColor  = .systemBackground.withAlphaComponent(0.3)
        tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterial)
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}
