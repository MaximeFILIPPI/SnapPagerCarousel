//
//  ExampleMapView.swift
//  Examples
//
//  Created by MaxBook Pro on 30/9/23.
//

import Foundation
import SwiftUI
import MapKit
import SnapPagerCarousel


struct Place: Hashable {
    
    var id: Self { self }
    
    var name: String
    var desc: String
    var icon: String
    var color: Color
    var latitude: CGFloat
    var longitude: CGFloat
    var pictureURL: String
    
}

struct ExampleMapView: View {
    
    let defaultPlace = Place(name: "", desc: "", icon: "", color: .red, latitude: 0, longitude:0, pictureURL: "")
    
    // Kōtō city, Central Tokyo location
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    // Our items for Map and SnapCarousel
    @State var places: [Place] = []
    
    // Selected item for Map and SnapPager
    @State var selectedPlace: Place?
    
    // Index of selected place for SnapPager
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
        .onChange(of: selectedPlace ?? defaultPlace) { oldValue, newValue in
            
            self.centerMapOnPlace(place: newValue)
            
        }
        .onAppear
        {
            self.loadPlaces()
        }
     
        
    }
    
    
    func loadPlaces()
    {
        // Need data
        
        places = [
                
            Place(name: "Odaiba Seaside Park", 
                  desc: "Coastal green space with views of the Rainbow Bridge & city, plus paths & a small Statue of Liberty.",
                  icon: "figure.and.child.holdinghands",
                  color: .blue,
                  latitude: 35.6281, 
                  longitude: 139.7736,
                  pictureURL: "https://lh3.googleusercontent.com/p/AF1QipM_9s8UCiGEkMfOB0zzgoPSXvbeBQVIWz6FA_ut=s1360-w1360-h1020"),
            
            
            Place(name: "Tokyo Big Sight",
                  desc: "Convention and exhibition center in Tokyo, Japan, and the largest one in the country.",
                  icon: "globe",
                  color: .brown,
                  latitude: 35.6308,
                  longitude: 139.7942,
                  pictureURL: "https://upload.wikimedia.org/wikipedia/commons/d/d1/20030727_27_July_2003_Tokyo_International_Exhibition_Center_Big_Sight_Odaiba_Tokyo_Japan.jpg"),
            
        
            Place(name: "Aomi Urban Sports Park",
                  desc: "Temporary venue and park in the Aomi district in the Tokyo Bay Zone",
                  icon: "figure.climbing",
                  color: .green,
                  latitude: 35.6330,
                  longitude: 139.7926,
                  pictureURL: "https://media.gettyimages.com/id/1210700393/photo/a-general-view-of-the-venue-during-the-sports-climbing-tokyo-2020-olympic-test-event-at-the.jpg?s=612x612&w=gi&k=20&c=V6umi1b_JEDblDGEb06Smaqw5HQNBGlAz_8fjSl0ggk="),
            
        
            Place(name: "Aqua City Odaiba",
                  desc: "large complex shopping center located next to Odaiba Marine Park which boasts a great location where you can see the center of Tokyo metropolis over the Statue of Liberty and the Rainbow Bridge.",
                  icon: "drop.halffull",
                  color: .cyan,
                  latitude: 35.6258,
                  longitude: 139.7769,
                  pictureURL: "https://c8.alamy.com/comp/2BW110T/aqua-city-mall-with-odaiba-fuji-building-behind-on-a-sunny-day-tokyo-japan-2BW110T.jpg"),
            
        
            Place(name: "Miraikan (National Museum of Emerging Science and Innovation)",
                  desc: "National Museum of Emerging Science and Innovation, simply known as the Miraikan, is a museum created by Japan's Science and Technology Agency.",
                  icon: "graduationcap.fill",
                  color: .red,
                  latitude: 35.6214,
                  longitude: 139.7796,
                  pictureURL: "https://res.klook.com/images/fl_lossy.progressive,q_65/c_fill,w_1295,h_863/w_80,x_15,y_15,g_south_west,l_Klook_water_br_trans_yhcmh3/activities/relinvmpqstko4nxngei/NationalMuseumofEmergingScienceandInnovation(Miraikan)AdmissionTicket.webp"),
        
        
            Place(name: "Palette Town Ferris Wheel",
                  desc: "Amusement ride, known as “Palette Town Daikanransha,” has been lit up in a special illumination every night.",
                  icon: "fireworks",
                  color: .purple,
                  latitude: 35.6295,
                  longitude: 139.7762,
                  pictureURL: "https://rimage.gnst.jp/livejapan.com/public/article/detail/a/00/00/a0000132/img/en/a0000132_parts_57b5957b6d955.jpg"),
            
        
            Place(name: "DiverCity Tokyo",
                  desc: "This park values Japan's unique view of nature and strives to maintain its natural beauty. If you're looking for a place to relax and recharge, this park is for you. It is also a place where children can have a lot of fun.",
                  icon: "music.mic",
                  color: .indigo,
                  latitude: 35.6256,
                  longitude: 139.7736,
                  pictureURL: "https://amazingthaisea.com/wp-content/uploads/2015/10/Diver-City-Tokyo-Plaza.jpg"),
                
        ]
        
        
        // Calculate the region that encompasses all the places
        centerMapOnAllPlaces()
        
    }
    
    
    func centerMapOnAllPlaces()
    {
        if let minLat = places.map({ $0.latitude }).min(),
           let maxLat = places.map({ $0.latitude }).max(),
           let minLon = places.map({ $0.longitude }).min(),
           let maxLon = places.map({ $0.longitude }).max()
        {
            let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
            
            // Add some padding in both latitude and longitude directions
                    
            let padding = 0.01 // Adjust the padding as needed
            let span = MKCoordinateSpan(latitudeDelta: maxLat - minLat + padding * 2, longitudeDelta: maxLon - minLon + padding * 2)
                    
            
            let region = MKCoordinateRegion(center: center, span: span)
            
            cameraPosition = .region(region)
        }
        
    }
    
    
    func centerMapOnPlace(place: Place)
    {
        withAnimation {
            
            cameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude), latitudinalMeters: 1000, longitudinalMeters: 1000))
            
        }
        
    }

    
}



struct PlaceCardView: View {
    
    @State var place: Place
    
    var body: some View {
        
        ZStack
        {
            HStack{
                
                AsyncImage(url: URL(string: place.pictureURL)! ){ image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray
                }
                .scaledToFill()
                .frame(width: 65, height: 65)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment:.leading, spacing: 8)
                {
                    Text(place.name)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                    
                    Text(place.desc)
                        .font(.caption)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                .padding(.leading, 8)
                
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .frame(height: 100)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
        )
        
    }
    
}


#Preview {
    ExampleMapView()
}
