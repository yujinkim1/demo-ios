//
//  VStackView.swift
//  ViewLayout
//
//  Created by Yujin Kim on 2024-05-05.
//

import SwiftUI

struct VStackView: View {
    private let numbers: ClosedRange<Int> = 1...10
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 20
        ) {
            ForEach(numbers, id: \.self) {
                Text("Value is \($0)")
            }
        }
        .padding()
    }
}

#Preview {
    VStackView()
}
