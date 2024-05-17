//
//  RaccoonDemoApp.swift
//  RaccoonDemo
//
//  Created by devonly on 2024/05/03.
//

import SwiftUI
import Raccoon
import WebImage

@main
struct RaccoonDemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup(content: {
            ContentView()
        })
    }
    
    class AppDelegate: NSObject, UIApplicationDelegate, UIWindowSceneDelegate {
        func application(
            _ application: UIApplication,
            configurationForConnecting connectingSceneSession: UISceneSession,
            options: UIScene.ConnectionOptions
        ) -> UISceneConfiguration {
            let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
            config.delegateClass = AppDelegate.self
            return config
        }
        
        func application(
            _ application: UIApplication,
            willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
        ) -> Bool {
            return true
        }

        func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
        ) -> Bool {
            SVGImage.configure(coder: .SVGCoder)
            Raccoon.configure()
            return true
        }
    }
}
