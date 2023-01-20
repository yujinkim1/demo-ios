//
//  ContentView.swift
//  ObjectDetection
//
//  Created by yujinkim on 2023/01/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            HStack {
                VStack {
                    HostedViewController()
                        .ignoresSafeArea()
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.green)
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
