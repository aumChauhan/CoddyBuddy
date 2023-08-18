//  LottieAnimation.swift
//  Created by Aum Chauhan on 14/08/23.

import Foundation
import SwiftUI
import Lottie
import UIKit

struct Lottie: UIViewRepresentable {
    typealias UIViewType = UIView
    var fileName: String
    
    func makeUIView(context: UIViewRepresentableContext<Lottie>) -> UIView {
        
        let view = UIView(frame: .zero)
        
        let animation = LottieAnimation.named(fileName)
        let animationView = LottieAnimationView(animation: animation)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo:view.heightAnchor)
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<Lottie>) {}
}
