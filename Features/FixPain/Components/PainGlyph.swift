//
//  PainGlyph.swift
//  EverForm
//
//  Shared icon renderer for consistent pain tile icons
//

import SwiftUI

struct PainGlyph<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .frame(width: 28, height: 28, alignment: .center)
            .symbolRenderingMode(.hierarchical)
            .font(.system(size: 28, weight: .semibold, design: .rounded))
            .foregroundStyle(EFColor.painAccent)
            .padding(2)
    }
}