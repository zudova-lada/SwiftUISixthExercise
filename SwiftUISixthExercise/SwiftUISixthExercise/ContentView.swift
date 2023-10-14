//
//  ContentView.swift
//  SwiftUISixthExercise
//
//  Created by Лада Зудова on 14.10.2023.
//

import SwiftUI

private extension UIEdgeInsets {
    
    var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

struct DiagonalLayout: Layout {
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        return CGSize(width: proposal.width ?? 0, height: proposal.height ?? 0)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        for (index, subview) in subviews.enumerated() {
            let sideSize = bounds.size.height/CGFloat(subviews.count)
            let startX: CGFloat
            if index > 0 {
                startX = CGFloat(index) * (bounds.size.width-sideSize) / CGFloat(subviews.count - 1) + bounds.origin.x
            } else {
                startX = 0 + bounds.origin.x
            }
            
            let startY = CGFloat(index) * (bounds.size.height) / CGFloat(subviews.count) + bounds.origin.y
            
            print(sideSize)
            subview.place(at: CGPoint(x: startX, y: startY), proposal: ProposedViewSize(CGSize(width: sideSize, height: sideSize)))
        }
    }
}

enum LayoutKind: Int, CaseIterable {
    case diagonal
    case horizontal
}

struct ContentView: View {
    @State private var layoutKind: LayoutKind = .horizontal
    
    private var squareNumber: Int = 9
    
    private var layout: any Layout {
        switch layoutKind {
        case .diagonal:
            return DiagonalLayout()
        case .horizontal:
            return HStackLayout()
        }
    }
    
    private var nextLayout: LayoutKind {
        switch layoutKind {
        case .diagonal:
            return .horizontal
        case .horizontal:
            return .diagonal
        }
    }
    
    var body: some View {
        VStack {
            let anyLayout = AnyLayout(layout)
            anyLayout {
                GridRow {
                    ForEach(0..<squareNumber) { _ in
                        RoundedRectangle(cornerRadius: 5)
                            .aspectRatio(1.0, contentMode: .fit)
                            .onTapGesture {
                                withAnimation(.linear) {
                                    layoutKind = nextLayout
                                }
                            }
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
