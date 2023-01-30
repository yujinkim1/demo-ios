//
//  ContentView.swift
//  Restart
//
//  Created by yujinkim on 2022/09/25.
//

import SwiftUI

struct ContentView: View {
    //MARK: Property Wrapper
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
    var body: some View {
        ZStack {
            if isOnboardingViewActive {
                OnboardingView()
            } else {
                HomeView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
