import SwiftUI

struct OnlyProfilePhotoView: View {
    @StateObject var VM : ImageLoadingVM
    
    init(url: String, key: String) {
        _VM = StateObject(wrappedValue: ImageLoadingVM(url: url, key: key))
    }
    
    var body: some View {
        ZStack {
            if VM.isLoading {
                RoundedRectangle(cornerRadius: 11)
                    .frame(width: 45, height:45)
                    .foregroundColor(.gray.opacity(0.3))
                    .overlay {
                        LottieAnimationViews(fileName: "loadingImage")
                            .frame(width: 50, height: 50)
                    }
            } else if let image = VM.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height:45)
                    .clipShape(RoundedRectangle(cornerRadius: 11))
            }
        }
    }
}

