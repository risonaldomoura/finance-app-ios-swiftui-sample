//
//  StudyAppApp.swift
//  StudyApp
//
//  Created by Risonaldo Moura on 13/04/25.
//

import SwiftUI

@main
struct StudyAppApp: App {
    @State private var showOnboarding = true
    @State private var isAuthenticated = false
    
    var body: some Scene {
        WindowGroup {
            if showOnboarding {
                OnboardingView(viewModel: OnboardingViewModel(onAuthenticationSuccess: {
                    isAuthenticated = true
                    showOnboarding = false
                }))
            } else {
                TabView {
                    DashboardView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    
                    CardSettingsView()
                        .tabItem {
                            Image(systemName: "creditcard.fill")
                            Text("Card")
                        }
                }
            }
        }
    }
}
