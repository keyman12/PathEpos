//
//  PathEPOSDemoApp.swift
//  PathEPOSDemo
//
//  Created by David Key on 29/08/2025.
//

import SwiftUI

@main
struct PathEPOSDemoApp: App {
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .background(Color(.systemBackground).ignoresSafeArea())
        }
    }
}
