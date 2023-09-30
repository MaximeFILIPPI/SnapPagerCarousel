

<p align="center">
  <img src="https://github.com/MaximeFILIPPI/SnapPagerCarousel/blob/main/Images/snap_carousel_banner.png" />
</p>

<p align="center">
    <img src="https://img.shields.io/badge/SwiftUI-5%2B-blue?style=flat&color=%2326c281%20&link=https%3A%2F%2Fdeveloper.apple.com%2Fxcode%2Fswiftui%2F" />
    <img src="https://img.shields.io/badge/iOS-17%2B-blue?style=flat&color=%239f5afd&link=https%3A%2F%2Fdeveloper.apple.com%2Fios%2F" alt="Platforms" />
    <a href="https://github.com/MaximeFILIPPI/SnapPagerCarousel/blob/main/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>

# SnapPager

A lightweight SwiftUI View for iOS 17 (and newer) that provides you an easy-to-use Pager / Carousel like TabView but better, faster, stronger 💪. 

It allows you to create a horizontally scrolling list of items and custom views with centered snapping behavior, making it perfect for creating your own sliding views, images gallery, product carousels, onboarding, showcase, etc...

It is also highly performant, as the views are lazy loaded making it ideal for displaying a infinite number of pages efficiently.



![screenshot](https://github.com/MaximeFILIPPI/SnapPagerCarousel/blob/main/Images/Simulator%20Screen%20Recording%20-%20iPhone%2015%20Pro%20-%202023-10-01%20at%2003.42.31.gif)
![screenshot](https://github.com/MaximeFILIPPI/SnapPagerCarousel/blob/main/Images/Simulator%20Screen%20Recording%20-%20iPhone%2015%20Pro%20-%202023-09-30%20at%2023.55.03.gif?raw=true)




## Features

✅ Easy-to-use

✅ 100% SwiftUI

✅ Automatically handles user interactions

✅ Horizontal scrolling with snapping behavior

✅ Supports binding and controls for both selection modes: item or index.

✅ Supports any kind items: struct / class / objects (note: Must be Hashable)


⚠️ Experimental: overlap and spacing between items 


## Requirements

- iOS 17.0+
- SwiftUI 5.0+



## Installation

**Swift Package Manager:**

`XCode` > `File` > `Add Package Dependency...`  

Enter the following `URL` of the repository into the search: 
```html
https://github.com/MaximeFILIPPI/SnapPagerCarousel
```
Follow the prompts to complete the installation.


## Basic Usage

Here is an example of how to integrate and use SnapPager in your SwiftUI views:

```swift
import SwiftUI
import SnapPagerCarousel // <- Import

struct ContentView: View {
    
    @State var items: [YourItemType] = []       // <- Your items (should be Hashable)
    @State var selectedItem: YourItemType?      // <- Should match your items type
    @State var selectedItemIndex: Int = 0       // <- This keeps track of the page index
    
    var body: some View {
        
        SnapPager(items: $items,
                  selection: $selectedItem,
                  currentIndex: $selectedItemIndex) { index, item in
            
            YourCustomView(item) // <- Your content to display for each page here
            
        }
        
    }
    
}
```

In this example, `items` is an array of custom object / struct / class that you want to use to display some infos in the pager. 
You can customize the appearance of each page by providing your own view inside the content closure.
The content closure returns an `index` and an `item` for your custom view (the ones corresponding to the page to load).


## How To Programmatically?

The `SnapPager` view automatically handles the horizontal paging and snapping behavior. 
If you wish to change the selected item and go to another one it is really easy.
You just have to set a new value for `selectedItem` or `selectedItemIndex` and it will automatically scroll to the position of the item wanted.

Example if you want to go to a certain position


```swift
// Function to navigate to the next page
func goToNextPage()
{
    self.selectedItemIndex += 1
}
```

or if you prefer to just change the item

```swift
// Function to navigate to the next item
func goToNextItem()
{
    self.selectedItem = items[selectedItemIndex+1]
}
```


## Customization (Experimental)

You can slightly customize the appearance of your pager by adjusting the `edgesOverlap` and `itemsMargin` properties that controls how much adjacent your pages should overlap when snapping. It gives a kind of carousel-like vibes to your pager. careful to not set the edge overlap too high or the native scrollview used by `SnapPager` will have hard time to find the correct item to scroll to if you programmatically change the value of the current item or index.

```swift
SnapPager(items: $items,
          selection: $selectedItem,
          currentIndex: $selectedItemIndex,
          edgesOverlap: 16, // Adjust as needed (controls overlap between pages)
          itemsMargin: 8    // Adjust as needed (controls margin between pages)
          ) { index, item in
          
    // Your content for each page here
    CustomView(item)
    
}
```

> **Note**
> Be careful to not set the `edgesOverlap` or `itemsMargin` too high as the native ScrollView that `SnapPager` use might lose track of the correct position of your items.


## Examples

Please refer to the directory [EXAMPLES](https://github.com/MaximeFILIPPI/SnapPagerCarousel/tree/main/Examples) for fully detailed code on how to achieve certain effects.

Here is how simple it is to bind the `SnapPager` to a `Map` (from `MapKit`); You just have to use the same `@State` variable for the `places` and `selectedPlace`:

```swift
import SwiftUI
import MapKit
import SnapPagerCarousel

struct ExampleMapView: View {

    @State private var cameraPosition: MapCameraPosition = .automatic
    
    // Same items for Map AND SnapCarousel
    @State var places: [Place] = []
    
    // Same selected item for Map AND SnapPager
    @State var selectedPlace: Place?
    
    // Index of selected place (if needed)
    @State var indexPlace: Int = 0
    
    
    var body: some View {
        
        ZStack(alignment: .bottom)
        {
            // Map SwiftUI
            Map(position: $cameraPosition, selection: $selectedPlace) {
                
                ForEach(places, id: \.self) { place in
                    
                    Marker(place.name,
                           systemImage: place.icon,
                           coordinate: CLLocationCoordinate2D(latitude: place.latitude,
                                                              longitude: place.longitude))
                    .tint(place.color)
                    .tag(place)
                    
                }
                
            }.mapStyle(.standard(pointsOfInterest: .excludingAll))
            
            
            // Bottom Cards SlideShow
            SnapPager(items: $places,
                      selection: $selectedPlace,
                      currentIndex: $indexPlace,
                      edgesOverlap: 40,
                      itemsMargin: 10) { index, place in
             
                PlaceCardView(place: place)
                
            }.frame(maxHeight: 100)
            
        }
        
    }
    
}
```


Another example for a fullscreen ViewPager experience with custom PagerIndicator

```swift
import SwiftUI
import SnapPagerCarousel

struct ExampleOnBoardingView: View {
    
    @State var pages: [OnBoarding] = [ ]
    
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
            
            // Indicator at the bottom
            PagerIndicatorView(pages: $pages,
                               pageSelected: $pageSelected)
            
        }
        .background(Color.black)
        .ignoresSafeArea()
    }
    
}


// -------------------------------------------------------------

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
```



## License

SnapPager is available under the MIT license. See the [LICENSE](https://github.com/MaximeFILIPPI/SnapPagerCarousel/blob/main/LICENSE) file for more details.


## Credits

**SnapPager** is developed and maintained by [Maxime FILIPPI].

If you encounter any issues or have suggestions for improvements, please [open an issue](https://github.com/MaximeFILIPPI/SnapPagerCarousel/issues).
