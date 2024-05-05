//
//  HStackView.swift
//  ViewLayout
//
//  Created by Yujin Kim on 2024-05-05.
//

import SwiftUI

struct HStackView: View {
    private let numbers: ClosedRange<Int> = 1...10
    
    var body: some View {
        HStack(
            alignment: .top,
            spacing: 20
        ) {
            ForEach(numbers, id: \.self) {
                Text("Value is \($0)")
            }
            
            VStack {
                ForEach(numbers, id: \.self) {
                    Text("Value is \($0)")
                }
            }
        }
    }
}

#Preview {
    HStackView()
}
