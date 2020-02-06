//
// Copyright (c) Vatsal Manot
//

#if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)

import Swift
import SwiftUI
import UIKit

/// A view that paginates its children along a given axis.
public struct PaginationView<Page: View>: View {
    private let children: [UIHostingController<Page>]
    private let axis: Axis
    private let pageIndicatorAlignment: Alignment
    
    @State private var currentPageIndex = 0
    @DelayedState private var progressionController: ProgressionController?
    
    public init(
        pages: [Page],
        axis: Axis = .horizontal,
        pageIndicatorAlignment: Alignment? = nil
    ) {
        self.children = pages.map(_UIHostingController.init)
        self.axis = axis
        self.pageIndicatorAlignment = pageIndicatorAlignment ?? (axis == .horizontal ? .center : .leading)
    }
    
    public init(
        axis: Axis = .horizontal,
        pageIndicatorAlignment: Alignment? = nil,
        @ArrayBuilder<Page> content: () -> [Page]
    ) {
        self.init(
            pages: content(),
            axis: axis,
            pageIndicatorAlignment: pageIndicatorAlignment
        )
    }
    
    private var pageControlPadding: Edge.Set {
        switch pageIndicatorAlignment {
        case .bottomLeading, .topLeading : return .leading
        case .bottomTrailing, .topTrailing: return .trailing
        default: return .init()
        }
    }
    
    public var body: some View {
        ZStack(alignment: pageIndicatorAlignment) {
            _PaginationView(
                children: children,
                axis: axis,
                pageIndicatorAlignment: pageIndicatorAlignment,
                currentPageIndex: $currentPageIndex,
                progressionController: $progressionController
            )
            
            PageControl(
                numberOfPages: children.count,
                currentPage: $currentPageIndex
            ).rotationEffect(
                axis == .vertical
                    ? .init(degrees: 90)
                    : .init(degrees: 0)
            ).padding(pageControlPadding)
        }
        .environment(\.progressionController, progressionController)
    }
}

#endif
