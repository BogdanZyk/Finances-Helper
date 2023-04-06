//
//  Finances_HelperApp.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import SwiftUI

@main
struct Finances_HelperApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appDelegate.appEnvironment.rootVM)
        }
    }
}
