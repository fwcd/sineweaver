//
//  ExpansionToggle.swift
//  Sineweaver
//
//  Created on 13.03.25
//

import SwiftUI

struct ExpansionToggle: View {
    @Binding var isExpanded: Bool
    
    var body: some View {
        Button {
            isExpanded = !isExpanded
        } label: {
            Image(systemName: isExpanded ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
        }
    }
}

#Preview {
    @Previewable @State var isExpanded = false
    
    ExpansionToggle(isExpanded: $isExpanded)
}
