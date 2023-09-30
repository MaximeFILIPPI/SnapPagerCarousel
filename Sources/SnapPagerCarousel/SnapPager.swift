// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI


public struct SnapPager <Content: View, T: Hashable>: View {
    
    private let TAG: String = "SnapPager ::"
    
    
    @Binding var items: [T]
    
    @Binding var selection: T?
    
    @Binding var currentIndex: Int
    
    
    var edgesOverlap: CGFloat = 0
    
    var itemSpacing: CGFloat = 0
    
    var content: (T) -> Content
    
    
    @State private var realSelection: T?
    
    @State private var scrollPosition: CGPoint = .zero
    
    @State private var isVisible: Bool = false
    
    @State private var contentSize: CGSize = .zero
    
    @State private var prefKeyScroller: String = "snapPager"
    
    @State private var isScrolling: Bool = false
    
    @State private var isSelecting: Bool = false
    
    
    public init(items: Binding<[T]>,
                selection: Binding<T?>,
                currentIndex: Binding<Int>,
                edgesOverlap: CGFloat = 0,
                itemsMargin: CGFloat = 0,
                content: @escaping (T) -> Content,
                prefKeyScroller: String? = nil)
    {
        self._items = items
        self._selection = selection
        self._currentIndex = currentIndex
        self.edgesOverlap = abs(edgesOverlap)
        self.itemSpacing = abs(itemsMargin)
        self.content = content
        self.prefKeyScroller = prefKeyScroller ?? "snapPager"
        
        if selection.wrappedValue != nil
        {
            self.realSelection = selection.wrappedValue!
        }
    }
    
    
    public var body: some View {
        
        GeometryReader { proxy in
            
            let _ = updateContentSize(proxy.size)
            
            VStack(alignment: .leading)
            {
                ScrollView(.horizontal, showsIndicators: false)
                {
                    LazyHStack(spacing: 0)
                    {
                        ForEach(Array(items.enumerated()), id: \.element) { index, item in

                            ZStack
                            {
                                content(item)
                                    .padding(.horizontal, itemSpacing)
                                    .frame(maxWidth: proxy.size.width - edgesOverlap*2)
                                    .containerRelativeFrame(.horizontal)
                            }
                            .id(index)
                            .clipped()
                            .frame(width: proxy.size.width - edgesOverlap*2, alignment: .center)
                            
                        }
                        
                        
                    }
                    .scrollTargetLayout()
                    .background(GeometryReader { geometry in
                        Color.clear
                            .preference(key: SnapPagerPreferenceKey.self, value: geometry.frame(in: .named(prefKeyScroller)).origin)
                        
                    })
                    .onPreferenceChange(SnapPagerPreferenceKey.self) { value in
                        self.scrollPosition = value
                        self.readPositionScrollView()
                    }
                }
                .safeAreaPadding(.horizontal, edgesOverlap)
                .coordinateSpace(name: prefKeyScroller)
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $realSelection)
            }
            
        }
        .onChange(of: selection) { oldValue, newValue in
            
            if !isScrolling
            {
                self.isSelecting = true
                
                withAnimation {
                    self.realSelection = newValue
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                    self.isSelecting = false
                }

            }
            
        }
        .onChange(of: currentIndex) { oldValue, newValue in
            
            if currentIndex < items.count && !isSelecting
            {
                withAnimation {
                    self.selection = items[currentIndex]
                }
            }
            
        }
        .onAppear {
            
            self.isVisible = true
            
            if currentIndex >= 0 && currentIndex < items.count
            {
                self.selection = items[currentIndex]
            }
        }
        .onDisappear {
            self.isVisible = false
        }
        
    }
    
    
    func updateContentSize(_ proxySize: CGSize)
    {
        DispatchQueue.main.async {
            self.contentSize = proxySize
        }
    }
   
    func readPositionScrollView()
    {
        let scrollPosition = -scrollPosition.x
        
        let margins = edgesOverlap * 2
        
        let screenContentWidth = self.contentSize.width
        
        if isVisible
        {
            if screenContentWidth > 0
            {
                // Calculate the center of the visible area
                let visibleCenterX = scrollPosition + screenContentWidth / 2.0
                
                // Calculate the effective item width considering the overlap
                let effectiveItemWidth = screenContentWidth - margins
                
                // Calculate the current index based on the center of the visible area
                let index = Int(visibleCenterX / effectiveItemWidth)
                
            
                DispatchQueue.main.async {
                    
                    self.isScrolling = true
                    
                    self.currentIndex = index
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                        self.isScrolling = false
                    }
                    
                }
                
            }
            
        }
        
    }
    
}


struct SnapPagerPreferenceKey: PreferenceKey
{
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) { }
}

