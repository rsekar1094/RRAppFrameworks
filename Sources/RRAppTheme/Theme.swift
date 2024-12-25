//
//  Theme.swift
//  ChatGPTChat
//
//  Created by Raj S on 28/01/24.
//

import Foundation
import SwiftUI

public protocol Theme {
    var font: ThemeFont { get }
    var color: ThemeColor { get }
}

public protocol ThemeFont {
    var headline: Font { get }
    var body: Font { get }
}

public protocol ThemeColor {
    var primary: Color { get }
    var secondary: Color { get }
    var error: Color { get }
}


public struct ThemeMock: Theme {
    public let font: ThemeFont = ThemeFontMock()
    public let color: ThemeColor = ThemeColorMock()    
    public init() {}
}

public struct ThemeFontMock: ThemeFont {
    public let headline: Font = .headline
    public let body: Font = .body
}

public struct ThemeColorMock: ThemeColor {
    public let primary: Color = .blue
    public let secondary: Color = .pink
    public let error: Color = .red
}
