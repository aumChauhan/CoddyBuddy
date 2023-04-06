import SwiftUI

struct TermsOfService: View {
    
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    
    var body: some View {
        List {
            Section {
                VStack {
                    HStack(spacing:10) {
                        Image("CoddyBuddyLogoF")
                            .resizable()
                            .frame(width: 40, height: 40)
                        
                        VStack(alignment: .leading) {
                            Text("Terms Of Service")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.leading)
                            
                            Text("support@coddybuddy.com")
                                .font(.caption)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 3)
                }
            }
            
            Section {
                VStack(spacing:2) {
                    ForEach(privacyPolicyContent.contentArrayTitle, id: \.self) { index in
                        HStack {
                            Text("\(index)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        Divider()
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Terms Of Service")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TermsOfService_Previews: PreviewProvider {
    static var previews: some View {
        TermsOfService()
    }
}
