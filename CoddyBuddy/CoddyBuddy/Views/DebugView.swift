import SwiftUI

struct DebugView: View {
    var body: some View {
        VStack {
            LottieAnimationViews(fileName: "64730-crying")
                .frame(width: 150, height: 150)
        }
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView()
    }
}
