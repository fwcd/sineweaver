//
//  MultiSlider2D.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct MultiSlider2D<Value, Background>: View where Value: BinaryFloatingPoint, Background: ShapeStyle {
    var size: CGFloat? = nil
    @Binding var thumbPositions: [Vec2<Value>]
    var thumbOptions: [ThumbOptions] = []
    var axes: Vec2<AxisOptions>
    var background: Background
    var onPressChange: ((Int?) -> Void)? = nil
    
    @GestureState private var draggedThumbIndex: Int?
    
    private var width: CGFloat {
        size ?? ComponentDefaults.padSize
    }
    private var height: CGFloat {
        size ?? width
    }
    
    private var viewThumbPositions: [CGPoint] {
        thumbPositions.map {
            CGPoint(
                x: CGFloat(axes.x.range.normalize($0.x)) * width,
                y: CGFloat(1 - axes.y.range.normalize($0.y)) * height
            )
        }
    }
    
    struct AxisOptions {
        var range: ClosedRange<Value> = -1...1
        var label: String? = nil
    }
    
    struct ThumbOptions {
        var isEnabled = true
    }
    
    var body: some View {
        let labelPadding: CGFloat = ComponentDefaults.labelPadding
        
        ZStack {
            let viewThumbPositions = self.viewThumbPositions
            ForEach(Array($thumbPositions.enumerated()), id: \.offset) { (i, $pos) in
                let options = thumbOptions(at: i)
                Thumb(isEnabled: options.isEnabled)
                    .position(viewThumbPositions[i])
            }
        }
        .frame(width: width, height: height, alignment: .center)
        .background(background)
        .overlay(alignment: .trailing) {
            if let label = axes.y.label {
                ComponentLabel(label, orientation: .vertical)
                    .padding(labelPadding)
            }
        }
        .overlay(alignment: .bottom) {
            if let label = axes.x.label {
                ComponentLabel(label)
                    .padding(labelPadding)
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .updating($draggedThumbIndex) { value, state, _ in
                    guard let draggedThumbIndex = state ?? viewThumbPositions
                        .enumerated()
                        .filter({ thumbOptions(at: $0.offset).isEnabled })
                        .min(by: ascendingComparator { ($0.element - value.startLocation).length })?
                        .offset else { return }
                    
                    state = draggedThumbIndex
                    thumbPositions[draggedThumbIndex] = .init(
                        x: axes.x.range.clamp(axes.x.range.denormalize(Value(value.location.x / width))),
                        y: axes.y.range.clamp(axes.y.range.denormalize(Value(1 - value.location.y / height)))
                    )
                }
        )
        .onChange(of: draggedThumbIndex) {
            onPressChange?(draggedThumbIndex)
        }
    }
    
    private func thumbOptions(at index: Int) -> ThumbOptions {
        index >= 0 && index < thumbOptions.count ? thumbOptions[index] : .init()
    }
}

#Preview {
    @Previewable @State var thumbPositions: [Vec2<Double>] = [
        Vec2(x: 0, y: 0),
        Vec2(x: 0.1, y: 0),
        Vec2(x: 0, y: 0.1),
    ]
    
    // TODO: Convenience initializer for background
    MultiSlider2D(
        thumbPositions: $thumbPositions,
        thumbOptions: [
            .init(isEnabled: false),
        ],
        axes: .init(
            x: .init(),
            y: .init()
        ),
        background: ComponentDefaults.padBackground
    )
}
