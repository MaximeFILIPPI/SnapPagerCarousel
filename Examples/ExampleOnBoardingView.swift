//
//  ExampleOnBoardingView.swift
//  Examples
//
//  Created by MaxBook Pro on 1/10/23.
//

import SwiftUI
import SnapPagerCarousel

struct OnBoarding : Hashable
{
    var id: Self { self }
    
    var title: String
    var desc: String
    var imgUrl: String
}

struct ExampleOnBoardingView: View {
    
    @State var pages: [OnBoarding] = [ 
        
        OnBoarding(title: "Imagine",
                   desc: "Step into a world where your wildest dreams and creative visions come to life. Explore the endless horizons of your imagination, all in one place.",
                   imgUrl: "https://images.unsplash.com/photo-1609151712779-4f86b3de7308?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=3474&q=80"),
        
        OnBoarding(title: "BUILDING",
                   desc: "You are the foundation, and we give you the tools and resources to construct and shape a better tomorrow.",
                   imgUrl: "https://images.unsplash.com/photo-1683009426952-13567b4fa28b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=3419&q=80"),
        
        OnBoarding(title: "THE FUTURE",
                   desc: "Together, we're pioneering new paths and setting the stage for the next era of possibilities. A world where all your dreams come true.",
                   imgUrl: "https://www.arabianbusiness.com/cloud/2022/07/26/The-Line-Project-19-573x1024.jpg"),
    ]
    
    @State var pageSelected: OnBoarding?
    @State var pageIndex: Int = 0
    
    var body: some View {
        
        ZStack(alignment:.bottom)
        {
            // Pager Mode
            SnapPager(items: $pages,
                      selection: $pageSelected,
                      currentIndex: $pageIndex) { index, page in
                
                OnBoardingPageView(page: page, position: index)
            }
            
            
            PagerIndicatorView(pages: $pages,
                               pageSelected: $pageSelected)
            
        }
        .background(Color.black)
        .ignoresSafeArea()
    }
    
    
    
    
}


struct OnBoardingPageView: View {
    
    let page: OnBoarding
    let position: Int
    
    var action: (()->())? = nil
    
    var body: some View
    {
        
        ZStack(alignment:.bottom)
        {
            AsyncImage(url: URL(string: page.imgUrl)! ){ image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray
            }
            .scaledToFill()
            .frame(maxWidth: UIScreen.main.bounds.size.width, maxHeight: UIScreen.main.bounds.size.height)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            LinearGradient(colors: [Color.clear, Color.clear, Color.black], startPoint: .top, endPoint: .bottom)
                .opacity(0.75)
            
            VStack(alignment: .leading, spacing: 12)
            {
                
                Text("\(position+1) -")
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                HStack
                {
                    
                    Text(page.title.uppercased())
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    
                }
                    
                Text(page.desc)
                    .font(.callout)
                    .fontWeight(.regular)
                    .foregroundStyle(.white)
                    .opacity(0.8)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    
                Spacer().frame(height: 64)
                
            }
            .frame(maxWidth: .infinity)
            .padding()
            
        }
        
    }
    
}


struct PagerIndicatorView: View {
    
    @Binding var pages: [OnBoarding]
    
    @Binding var pageSelected: OnBoarding?
    
    
    var body: some View
    {
        // Custom pager Indicator
        HStack
        {
            ForEach(pages, id: \.self) { page in
                
                Button(role: .none) {
                    
                    self.selectPage(page)
                    
                } label: {
                    
                    Capsule()
                        .fill(.white)
                        .opacity(page == pageSelected ? 0.5 : 0.25)
                        .frame(width: page == pageSelected ? 22 : 8, height: 8)
                }
                
            }
            
        }
        .padding(.bottom, 48)
    }
    
    
    func selectPage(_ page: OnBoarding)
    {
        withAnimation {
            self.pageSelected = page
        }
    }
    
}


#Preview {
    ExampleOnBoardingView()
}
