# SnapPager

**SnapPager** is a SwiftUI view library for iOS 17+ that provides an easy-to-use Snap ViewPager/Carousel for your iOS app. It allows you to create a horizontally scrolling list of items with snapping behavior, making it perfect for creating your own sliding views, images gallery, product carousels, onboarding showcase, or any kind of scrollable content that needs precise item alignment and to snap neatly into place as the user scrolls.

It is also highly performant, with lazy loading of the view making it ideal for displaying a infinite number of pages efficiently.

![screenshot](https://github.com/MaximeFILIPPI/SnapPagerCarousel/blob/main/Images/Simulator%20Screen%20Recording%20-%20iPhone%2015%20Pro%20-%202023-09-30%20at%2023.55.03.gif?raw=true)

## Features

✅ Easy-to-use

✅ Highly customizable (use your own custom views)

✅ Horizontal scrolling with snapping behavior

✅ Supports binding for item selection and index

✅ Supports any kind of hashable struct / class / objects as items

✅ Automatically handles user interactions

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


## Usage

Here is a basic example of how to integrate and use SnapPager in your SwiftUI views:

```swift
import SwiftUI
import SnapPagerCarousel // <- Import

struct ContentView: View {
    
    @State var items: [YourItemType] = []   // <- Your items (can be anything Hashable)
    @State var selectedItem: YourItemType?  // <- Should match your items type
    @State var indexItem: Int = 0           // <- This keeps track of the page index
    
    var body: some View {
        
        SnapPager(items: $items,
                  selection: $selectedItem,
                  currentIndex: $indexItem) { item in
            
            YourCustomView(item) // <- Content display for each page here (can be replace by any of your views)
            
        }
        
    }
    
    // Load your items into carouselItems
    
}
```

In this example, `items` is an array of custom object / struct / class that you want to use to display some infos in the pager. 
The `SnapPager` view automatically handles the horizontal paging and snapping behavior for you. 
You can customize the appearance of each page by providing your own view inside the content closure.


## Customization

You can customize the appearance of your pager by adjusting the `edgesOverlap` property that controls how much adjacent your pages should overlap when snapping.

```swift
SnapPager(items: $carouselItems,
          selection: $carouselSelection,
          currentIndex: $carouselIndex,
          edgesOverlap: 16, // Adjust as needed
          itemsMargin: 8    // Adjust as needed
          ) { item in
    // Your content for each page here
    CustomView(item)
}
```


## License

SnapPager is available under the MIT license. See the [LICENSE](https://github.com/MaximeFILIPPI/SnapPagerCarousel/blob/main/LICENSE) file for more details.


## Credits

**SnapPager** is developed and maintained by [Maxime FILIPPI].

If you encounter any issues or have suggestions for improvements, please [open an issue](https://github.com/MaximeFILIPPI/SnapPagerCarousel/issues).
