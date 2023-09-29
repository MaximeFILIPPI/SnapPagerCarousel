// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI


public struct SnapPager <Content: View, T: Hashable>: View {
    
    private let TAG: String = "SnapPager ::"
    
    
    @Binding var items: [T]
    
    @Binding var selection: T?
    
    @Binding var currentIndex: Int
    
    
    var edgesOverlap: CGFloat = 0
    
    var content: (T) -> Content
    
    
    private let itemSpacing: CGFloat = 0
    
    
    @State private var scrollPosition: CGPoint = .zero
    
    @State private var isVisible: Bool = false
    
    @State private var contentSize: CGSize = .zero
    
    
    @State private var prefKeyScroller: String = "snapPager"
    
    
    @State private var isScrolling: Bool = false
    
    
    public init(items: Binding<[T]>,
                selection: Binding<T?>,
                currentIndex: Binding<Int>,
                edgesOverlap: CGFloat,
                content: @escaping (T) -> Content,
                prefKeyScroller: String? = nil)
    {
        self._items = items
        self._selection = selection
        self._currentIndex = currentIndex
        self.edgesOverlap = edgesOverlap
        self.content = content
        self.prefKeyScroller = prefKeyScroller ?? "snapPager"
        self.isScrolling = isScrolling
    }
    
    
    public var body: some View {
        
        GeometryReader { proxy in
            
            let _ = updateContentSize(proxy.size)
            
            VStack(alignment: .leading)
            {
                ScrollView(.horizontal, showsIndicators: false)
                {
                    LazyHStack(spacing: itemSpacing)
                    {
                        ForEach(items, id: \.self) { item in

                            ZStack
                            {
                                content(item)
                                    .frame(maxWidth: proxy.size.width - edgesOverlap*2)
                                    .containerRelativeFrame(.horizontal)
                            }
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
                .scrollPosition(id: $selection)
            }
            
        }
        .onChange(of: currentIndex) { oldValue, newValue in
            
            print(TAG, "currentIndex = \(currentIndex) / isScrolling = \(isScrolling)")
            
            if !isScrolling && currentIndex < items.count
            {
                withAnimation {
                    self.selection = items[currentIndex]
                }
            }
            
        }
        .onAppear {
            self.isVisible = true
            self.selection = items[currentIndex]
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
        var margins = edgesOverlap * 2
        
        if ((edgesOverlap * 2) > (self.contentSize.width / 2))
        {
            margins = ( (edgesOverlap * 2) - (self.contentSize.width / 2) ) * 2
        }
        
        let widthContent = abs(self.contentSize.width - margins)//(edgesOverlap*2))
        
        let scrollPosition = abs(scrollPosition.x)
        
        
        if isVisible {
            
            if widthContent > 0
            {
                let index = Int((scrollPosition + 0.5 * widthContent) / widthContent)
                
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

