//
//  EnumPicker.swift
//  Sineweaver
//
//  Created on 11.01.25
//

import SwiftUI

public struct EnumPicker<Label, Value>: View
    where
        Label: View,
        Value: CaseIterable & CustomStringConvertible & Hashable,
        Value.AllCases: RandomAccessCollection,
        Value.AllCases.Index == Int {
    @Binding private var selection: Value
    private let label: Label
    
    public init(selection: Binding<Value>, label: Label) {
        self._selection = selection
        self.label = label
    }
    
    public var body: some View {
        Picker(selection: $selection, label: label) {
            ForEach(Value.allCases, id: \.self) { value in
                Text(value.description).tag(value)
            }
        }
    }
}

extension EnumPicker where Label == EmptyView {
    public init(selection: Binding<Value>) {
        self.init(selection: selection, label: EmptyView())
    }
}
