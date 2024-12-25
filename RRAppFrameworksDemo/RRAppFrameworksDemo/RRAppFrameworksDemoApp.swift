//
//  RRAppFrameworksDemoApp.swift
//  RRAppFrameworksDemo
//
//  Created by Raj S on 25/12/24.
//

import SwiftUI
import RRAppNetwork
import RRAppUtils
import RRAppTheme
import RRAppExtension

@main
struct RRAppFrameworksDemoApp: App {
    
    @State var isLoaded: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isLoaded {
                ContentView()
            } else {
                Color.white
                    .onAppear {
                        Resolver.shared.add(ConfigMock(),key: String(reflecting: Config.self))
                        Resolver.shared.add(URLSessionNetworkManager(),key: String(reflecting: NetworkService.self))
                        Resolver.shared.add(DarkTheme(),key: String(reflecting: Theme.self))
                        
                        isLoaded = true
                }
            }
        }
    }
}
