import SwiftUI
import Lottie
import UIKit

struct LottieAnimationViews: UIViewRepresentable {
    typealias UIViewType = UIView
    var fileName: String
    
    func makeUIView(context: UIViewRepresentableContext<LottieAnimationViews>) -> UIView {
        
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
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieAnimationViews>) {}
}
