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
            VStack {
                HostedViewController()
            }
            VStack {
                Text("yolov7")
            }
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10.0))
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
