//
//  Inject+SwiftUI.swift
//  RRAppBaseFrameworks
//
//  Created by Raj S on 25/12/24.
//

import Foundation
import SwiftUI

struct MockInjectorsForPreviews: ViewModifier {
    
    let mockAdditionBlock: () -> Void
    @State var isMockAdded: Bool = false
    
    func body(content: Content) -> some View {
        Color.white
            .onAppear {
                mockAdditionBlock()
                isMockAdded = true
            }
    }
}

public extension View {
    @ViewBuilder
    func addMockForPreviews(mockAdditionBlock: @escaping () -> Void) -> some View {
        self.modifier(MockInjectorsForPreviews(mockAdditionBlock: mockAdditionBlock))
    }
}

public struct MockInjectorView<ContentView: View>: View {
    
    let mockAdditionBlock: () -> Void
    let contentView: () -> ContentView
    @State var isMockAdded: Bool = false
    
    public init(
        mockAdditionBlock: @escaping () -> Void,
        contentView: @escaping () -> ContentView
    ) {
        self.mockAdditionBlock = mockAdditionBlock
        self.contentView = contentView
    }
    
    public var body: some View {
        if isMockAdded {
            contentView()
        } else {
            Color.white
                .onAppear {
                    mockAdditionBlock()
                    isMockAdded = true
                }
        }
    }

}
