//
//  HomeView.swift
//  Restart
//
//  Created by yujinkim on 2022/09/25.
//

import SwiftUI

struct HomeView: View {
    //MARK: Property Wrapper
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = false
    var body: some View {
        VStack(spacing: 20) {
            Text("Home")
                .font(.largeTitle)
            Button(action: {
                //MARK: Some action
                isOnboardingViewActive = true
            }) {
                Text("Restart")
            }
        } //MARK: VStack
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
