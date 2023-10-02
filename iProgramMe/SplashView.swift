//
//  SplashView.swift
//  iProgramMe
//
//  Created by Pieter Yoshua Natanael on 28/09/23.
//


import SwiftUI

struct SplashView: View {
    @Binding var isShowingSplash: Bool
    
    var body: some View {
        // Customize your splash screen view with your company image or logo.
        // You can use an Image view here.
        // Replace "YourImageName" with your actual image asset name.
        Image("KarmAware")
            .resizable()
           // .scaledToFill()
            .edgesIgnoringSafeArea(.all)
            
            
            .onAppear {
                // After 3 seconds, hide the splash screen.
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        self.isShowingSplash = false
                    }
                }
            }
    }
}
