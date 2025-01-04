//
//  Enveloper.swift
//  Sineweaver
//
//  Created on 25.12.24
//

//import SwiftUI
//
//struct Enveloper<Value, Background>: View
//where Value: BinaryFloatingPoint,
//      Background: ShapeStyle {
//    var size: CGFloat? = nil
//    @Binding var thumbPositions: [CGPoint]
//    let xOptions: AxisOptions
//    let yOptions: AxisOptions
//    var background: Background
//    var onPressChange: ((Bool) -> Void)? = nil
//    
//    @State private var isPressed = false
//    
//    struct AxisOptions {
//        var range: ClosedRange<Value> = -1...1
//        var label: String? = nil
//    }
//    
//    var body: some View {
//        let width: CGFloat = size ?? 300
//        let height: CGFloat = size ?? width
//        let labelPadding: CGFloat = 5
//        Thumb()
//            .position(
//                x: CGFloat(xOptions.range.normalize(x)) * width,
//                y: CGFloat(1 - yOptions.range.normalize(y)) * height
//            )
//            .frame(width: width, height: height, alignment: .center)
//            .background(background)
//            .overlay(alignment: .trailing) {
//                if let label = yOptions.label {
//                    ComponentLabel(label, orientation: .vertical)
//                        .padding(labelPadding)
//                }
//            }
//            .overlay(alignment: .bottom) {
//                if let label = xOptions.label {
//                    ComponentLabel(label)
//                        .padding(labelPadding)
//                }
//            }
//            .gesture(
//                DragGesture(minimumDistance: 0)
//                    .onChanged { value in
//                        if !isPressed {
//                            isPressed = true
//                        }
//                        x = xOptions.range.clamp(xOptions.range.denormalize(Value(value.location.x / width)))
//                        y = yOptions.range.clamp(yOptions.range.denormalize(Value(1 - value.location.y / height)))
//                    }
//                    .onEnded { _ in
//                        isPressed = false
//                    }
//            )
//            .onChange(of: isPressed) {
//                onPressChange?(isPressed)
//            }
//    }
//}
//
//#Preview {
//    @Previewable @State var x: Double = 0
//    @Previewable @State var y: Double = 0
//    
//    VStack {
//        Slider2D(x: $x, label: "Sample X", y: $y, label: "Sample Y")
//        VStack(alignment: .leading) {
//            Text("x = \(x)")
//            Text("y = \(y)")
//        }
//        .fontDesign(.monospaced)
//    }
//}
