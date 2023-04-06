import SwiftUI

struct ReleaseNote: View {
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @State var ApplicationVersionNumber:Int = 1
    @State var ApplicationBuildNumber:Int = 0
    var body: some View {
        List {
            Section {
                VStack {
                    HStack(spacing:10) {
                        Image("CoddyBuddyLogoF")
                            .resizable()
                            .frame(width: 40, height: 40)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Version \(ApplicationVersionNumber).\(ApplicationBuildNumber)")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.leading)
                            
                            Text("CoddyBuddy")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 3)
                }
            }
            
            Section {
                HStack(spacing:10) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Current Version \(ApplicationVersionNumber).\(ApplicationBuildNumber)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.leading)
                        
                        Text("Released on 9/3/2023")
                            .font(.caption)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                }
                .padding(3)
            }
            
            Section {
                VStack(spacing:2) {
                    HStack {
                        Text("What's New")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    
                    VStack(spacing: 2) {
                        ForEach(releaseNoteContent.contentArray, id: \.self) { index in
                            HStack {
                                Text("* \(index)")
                                    .font(.subheadline)
                                    .fontWeight(.regular)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Release Note")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ReleaseNote_Previews: PreviewProvider {
    static var previews: some View {
        ReleaseNote()
    }
}
