//
//  MultiSlider2D.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct MultiSlider2D<Value, Background>: View where Value: BinaryFloatingPoint, Background: ShapeStyle {
    var width: CGFloat = ComponentDefaults.padSize
    var height: CGFloat = ComponentDefaults.padSize
    @Binding var thumbPositions: [Vec2<Value>]
    var thumbOptions: [ThumbOptions] = []
    var thumbCurve: ThumbCurveOptions? = nil
    var axes: Vec2<AxisOptions>
    var background: Background
    var onPressChange: ((Int?) -> Void)? = nil
    
    @GestureState private var draggedThumbIndex: Int?
    
    private var viewThumbPositions: [CGPoint] {
        thumbPositions.map {
            CGPoint(
                x: CGFloat(axes.x.range.normalize($0.x)) * width,
                y: CGFloat(1 - axes.y.range.normalize($0.y)) * height
            )
        }
    }
    
    private var thumbCurveHighlightViewPosition: CGPoint? {
        guard var pos = thumbCurve?.highlightPosition else { return nil }
        let viewThumbPositions = viewThumbPositions
        
        for (thumb1, thumb2) in zip(viewThumbPositions, viewThumbPositions.dropFirst()) {
            if pos <= 1 {
                return thumb1 * (1 - pos) + thumb2 * pos
            }
            pos -= 1
        }
        
        return viewThumbPositions.last
    }
    
    struct AxisOptions {
        var range: ClosedRange<Value> = -1...1
        var label: String? = nil
    }
    
    struct ThumbOptions {
        var enabledAxes: Vec2<Bool> = .init(x: true, y: true)
        var label: Label? = nil
        
        struct Label {
            var text: String
            var position: Position = .below
            
            enum Position: Hashable {
                case above
                case below
            }
        }
        
        var isEnabled: Bool {
            enabledAxes.x || enabledAxes.y
        }
    }
    
    struct ThumbCurveOptions {
        var stroke = false
        var fill = false
        var highlightPosition: Double? = nil
        
        var highlightIndex: Int? {
            highlightPosition.map { Int($0) }
        }
    }
    
    var body: some View {
        let labelPadding: CGFloat = ComponentDefaults.labelPadding
        let thumbSize: CGFloat = ComponentDefaults.thumbSize
        let thumbCurveHighlightColor = ComponentDefaults.highlightColor
        let thumbRadius = thumbSize / 2
        
        ZStack {
            let viewThumbPositions = self.viewThumbPositions
            if let thumbCurve {
                Canvas { ctx, size in
                    if thumbCurve.fill {
                        ctx.fill(Path { path in
                            guard let start = viewThumbPositions.first else { return }
                            path.move(to: start)
                            for pos in viewThumbPositions.dropFirst() {
                                path.addLine(to: pos)
                            }
                        }, with: .color(.gray.opacity(0.5)))
                    }
                    if thumbCurve.stroke {
                        for (i, (start, end)) in zip(viewThumbPositions, viewThumbPositions.dropFirst()).enumerated() {
                            ctx.stroke(Path { path in
                                let delta = end - start
                                let normal = (delta / delta.length) * thumbRadius
                                path.move(to: start + normal)
                                path.addLine(to: end - normal)
                            }, with: thumbCurve.highlightIndex == i ? .color(thumbCurveHighlightColor) : .foreground, style: ComponentDefaults.lineStyle)
                        }
                    }
                    if let highlightViewPos = thumbCurveHighlightViewPosition {
                        let size = CGSize(width: thumbSize, height: thumbSize)
                        ctx.fill(
                            Path(ellipseIn: CGRect(origin: highlightViewPos - CGVector(size / 2), size: size)),
                            with: .color(thumbCurveHighlightColor)
                        )
                    }
                }
            }
            ForEach(Array($thumbPositions.enumerated()), id: \.offset) { (i, $pos) in
                let options = thumbOptions(at: i)
                let viewPos = viewThumbPositions[i]
                let thumbStyle: AnyShapeStyle = ((thumbCurve?.highlightPosition).map { abs($0 - Double(i)) < 0.01 } ?? false)
                    ? AnyShapeStyle(thumbCurveHighlightColor)
                    : AnyShapeStyle(.foreground)
                Thumb(isEnabled: options.isEnabled, size: thumbSize)
                    .foregroundStyle(thumbStyle)
                    .position(viewPos)
                if let label = options.label {
                    let labelOffset = (label.position == .above ? -1 : 1) * ComponentDefaults.thumbLabelSpacing
                    ComponentLabel(label.text)
                        .position(x: viewPos.x, y: viewPos.y + labelOffset)
                }
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
                        .reversed() // We prioritize later values to make the ADSR envelope dragging work properly
                        .filter({ thumbOptions(at: $0.offset).isEnabled })
                        .min(by: ascendingComparator { ($0.element - value.startLocation).length })?
                        .offset else { return }
                    state = draggedThumbIndex
                    
                    let options = thumbOptions(at: draggedThumbIndex)
                    var pos = thumbPositions[draggedThumbIndex]
                    
                    if options.enabledAxes.x {
                        pos.x = axes.x.range.clamp(axes.x.range.denormalize(Value(value.location.x / width)))
                    }
                    if options.enabledAxes.y {
                        pos.y = axes.y.range.clamp(axes.y.range.denormalize(Value(1 - value.location.y / height)))
                    }
                    
                    thumbPositions[draggedThumbIndex] = pos
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
        Vec2(x: -0.6, y: 0),
        Vec2(x: -0.3, y: 0),
        Vec2(x: 0.3, y: 0.2),
        Vec2(x: 0.6, y: -0.2),
    ]
    
    MultiSlider2D(
        thumbPositions: $thumbPositions,
        thumbOptions: [
            .init(enabledAxes: .init(x: false, y: false), label: .init(text: "A")),
            .init(enabledAxes: .init(x: false, y: true), label: .init(text: "B", position: .above)),
            .init(enabledAxes: .init(x: true, y: false)),
        ],
        thumbCurve: .init(stroke: true),
        axes: .init(
            x: .init(),
            y: .init()
        ),
        background: ComponentDefaults.padBackground
    )
}
