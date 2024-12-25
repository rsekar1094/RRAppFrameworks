//
//  ContentView.swift
//  RRAppFrameworksDemo
//
//  Created by Raj S on 25/12/24.
//

import SwiftUI
import RRAppNetwork
import RRAppUtils
import RRAppTheme
import RRAppExtension

struct ContentView: View {
    
    @Inject
    var networkService: NetworkService
    
    @Inject
    var theme: Theme
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(theme.color.primary)
            
            Text("Hello, world!")
                .font(theme.font.headline)
                .foregroundStyle(theme.color.secondary)
        }
        .padding()
    }
}

#Preview {
    MockInjectorView(
        mockAdditionBlock: {
            NetworkServiceMock.add()
            ThemeMock.add()
        },
        contentView: {
            return ContentView()
        }
    )
}

extension ThemeMock {
    public static func add() {
        Resolver.shared.add(ThemeMock(),key: String(reflecting: Theme.self))
    }
}
