//
//  DarkTheme.swift
//  RRAppFrameworksDemo
//
//  Created by Raj S on 25/12/24.
//

import Foundation
import RRAppTheme
import SwiftUI

struct DarkTheme: Theme {
    let font: ThemeFont = DarkThemeFont()
    let color: ThemeColor = DarkThemeColor()
}

struct DarkThemeFont: ThemeFont {
    let headline: Font = .system(size: 24, weight: .bold)
    let body: Font = .system(size: 16, weight: .regular)
}

struct DarkThemeColor: ThemeColor {
    let primary: Color = .primary
    let secondary: Color = .secondary
    let error: Color = .red
}
