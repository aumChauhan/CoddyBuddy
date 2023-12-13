//  CustomNavigationView.swift
//  Created by Aum Chauhan on 17/07/23.

import SwiftUI
import SwiftUITrackableScrollView

struct NavigationHeaderView<TopLeading: View, TopTrailing: View, SubHeader: View, Content : View> : View {
    
    @State private var scrollViewContentOffset = CGFloat(0)
    @State private var scrollPosition: CGFloat = 0
    
    let title: String
    let content: Content
    let topLeading: TopLeading
    let alignLeft: Bool?
    let topTrailing: TopTrailing
    let subHeader: SubHeader?
    let refreshAction: (() -> Void)?
    
    init(
        title: String,
        alignLeft: Bool? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder topLeading: () -> TopLeading,
        @ViewBuilder topTrailing: () -> TopTrailing,
        @ViewBuilder subHeader: () -> SubHeader?,
        refreshAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.content = content()
        self.topLeading = topLeading()
        self.topTrailing = topTrailing()
        self.subHeader = subHeader()
        self.refreshAction = refreshAction
        self.alignLeft = alignLeft
    }
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            subContentView
        }
    }
}

extension NavigationHeaderView {
    
    private var subContentView: some View {
        ZStack(alignment: .top) {
            allContentTrackableScroll
                .padding(.horizontal, 20)
            
            // MARK: Header Toolbar
            VStack(spacing: 15) {
                HStack(alignment: .center) {
                    topLeading
                    if alignLeft ?? false {
                        // NIL
                    } else {
                        Spacer()
                    }
                    
                    // MARK: Pinned title
                    if scrollPosition > 45 {
                        Text(title)
                            .font(.poppins(.medium, 18))
                            .foregroundColor(.theme.primaryTitle)
                    }
                    
                    Spacer()
                    topTrailing
                }
                
                // Pinned search bar/segmented controll
                /*
                 if scrollPosition > UIScreen.main.bounds.width / 3.5 {
                 subHeader
                 }
                 */
            }
            .padding(.bottom, 10)
            .padding(.horizontal, 20)
            .background(Color.theme.background)
        }
    }
    
    private var allContentTrackableScroll: some View {
        TrackableScrollView(showIndicators: false, contentOffset: $scrollViewContentOffset) {
            VStack(spacing: 24) {
                
                // MARK: Refreshable Action
                if scrollPosition < -100 {
                    ProgressView2()
                        .onAppear {
                            refreshAction?()
                            HapticManager.warning()
                        }
                }
                
                VStack(alignment: .leading, spacing: 28) {
                    
                    // Header's white space
                    HStack(alignment: .center) {
                        topLeading
                        Spacer()
                        topTrailing
                    }
                    .opacity(0.0)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // MARK: Title 1
                        Text(title)
                            .font(.poppins(.bold, 32))
                            .foregroundColor(.theme.primaryTitle)
                        
                        // MARK: Search bar/segmented control
                        subHeader
                    }
                }
                
                // MARK: Main content
                LazyVStack(alignment: .leading, spacing: 15) {
                    content
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .onChange(of: scrollViewContentOffset) { oldValue, newValue in
            withAnimation(.spring()) {
                scrollPosition = scrollViewContentOffset
            }
        }
        
    }
}
