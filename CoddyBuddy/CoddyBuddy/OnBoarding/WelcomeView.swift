//  WelcomeView.swift
//  Created by Aum Chauhan on 21/07/23.

import SwiftUI

struct WelcomeView: View {
    
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
    
    @State private var buttonWidth:Double = UIScreen.main.bounds.width/1.15
    @State private var buttonOffset: CGFloat = 0
    @State private var isAnimating: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            Image("welcomeAssest")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
            Spacer()
            
            welcomeMessage
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .preferredColorScheme(.light)
        .edgesIgnoringSafeArea(.bottom)
        .opacity(isAnimating ? 1 : 0)
        .animation(.default, value: isAnimating)
        .onAppear {
            isAnimating = true
        }
    }
}

extension WelcomeView {
    
    // MARK: - Welcome Message
    private var welcomeMessage: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 14) {
                    // Greeting Message
                    VStack(alignment: .leading) {
                        Text("Welcome to")
                            .font(.poppins(.bold, 28))
                        
                        Text("CoddyBuddy")
                            .font(.poppins(.bold, 32))
                    }
                    
                    // Tag Line
                    Text("Unleash Your Coding Community")
                        .font(.poppins(.regular, 14))
                        .foregroundColor(.theme.secondaryTitle)
                    
                    // Drag Gesture
                    getStartedGesture
                }
                .foregroundColor(.white)
            }
        }
        .padding(25)
        .padding(.vertical, 10)
        .background(.black.opacity(0.95))
        .cornerRadius(25, corners: [.topLeft, .topRight])
    }
    
    // MARK: - Drag Gesture
    private var getStartedGesture: some View {
        ZStack{
            // Drag Gesture Background
            Capsule()
                .fill(Color.white.opacity(0.2))
            Capsule()
                .fill(Color.white.opacity(0.2))
                .padding(8)
            
            // Message
            Text("Get Started")
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .offset(x: 20)
            
            // Capsule(Dynamic width)
            HStack {
                Capsule()
                    .fill(Color.white.opacity(0.35))
                    .frame(width: buttonOffset + 80)
                Spacer()
            }
            
            // Circle(Draggable)
            HStack {
                ZStack{
                    Circle()
                        .foregroundColor(.white)
                    Circle()
                        .foregroundColor(.black.opacity(0.15))
                        .padding(8)
                    Image(systemName: "chevron.right.2")
                        .foregroundColor(.black)
                        .font(.system(size: 24, weight: .bold))
                }
                .frame(width: 80, height: 80, alignment: .center)
                .offset(x: buttonOffset)
                // Gesture Action
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            if gesture.translation.width > 0 && buttonOffset <= buttonWidth - 80 {
                                buttonOffset = gesture.translation.width
                            }
                            
                        }
                        .onEnded { _ in
                            withAnimation(Animation.easeOut(duration: 0.4)){
                                if buttonOffset > buttonWidth / 2 {
                                    HapticManager.success()
                                    buttonOffset = buttonWidth - 80
                                    isOnboardingViewActive = false
                                } else{
                                    hapticFeedback.notificationOccurred(.warning)
                                    buttonOffset = 0
                                }
                            }
                        }
                )
                Spacer()
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .padding(.vertical, 15)
    }
    
}
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
