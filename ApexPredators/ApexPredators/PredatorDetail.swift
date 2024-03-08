//
//  PredatorDetail.swift
//  ApexPredators
//
//  Created by Katherine Deegan on 3/7/24.
//

import SwiftUI
import MapKit

struct PredatorDetail: View {
    let predator: ApexPredator
    
    @State var position: MapCameraPosition
    
    var body: some View {
        
        // GeometryReader helps scale content based on device size
        // geo.size.width, geo.size.height correspond to screen's width/height
        GeometryReader { geo in
            // ScrollView to allow content to be scrollable
            // List view has scrolling built in
            // ScrollView acts like a VStack with one crucial difference: views are based around the center in ScrollView (based from top with VStack)
            ScrollView {
                ZStack (alignment: .bottomTrailing){
                    // background img
                    // LinearGradient - add gradient so ZStack Image fades into next view. stops: [] -> array indicating where you want to stop/change color in gradient
                    Image(predator.type.rawValue)
                        .resizable()
                        .scaledToFit()
                        .overlay {
                            // .clear to see backgroung image
                            // makes image appear to fade to black to match below VStack
                            LinearGradient(stops: [Gradient.Stop(color: .clear, location: 0.8),
                                                   Gradient.Stop(color: .black, location: 1)
                                                  ] , startPoint: .top, endPoint: .bottom)
                        }
                    
                    // dino img
                    Image(predator.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width/1.5, height: geo.size.height/3)
                        .scaleEffect(x: -1) // flips image (mirror), .scale can also scale image bigger/smaller (if you don't specity x/y)
                        .shadow(color: .black, radius: 7) // adds shadow
                        .offset(y: 20)
                }
                
                VStack(alignment: .leading) {
                    
                    // dino name
                    Text(predator.name)
                        .font(.largeTitle)
                     
                    // current location - using MapKit
                    NavigationLink {
                        PredatorMap(position: .camera(MapCamera(centerCoordinate: predator.location, distance: 1000, heading: 250, pitch: 80)))
                    } label: {
                        Map(position: $position) {
                            // add annotations (location pins) to map
                            Annotation(predator.name, coordinate: predator.location, content: {
                                Image(systemName: "mappin.and.ellipse")
                                    .font(.largeTitle)
                                    .imageScale(.large)
                                    .symbolEffect(.pulse)
                            })
                            .annotationTitles(.hidden)
                        }
                        .frame(height: 125)
                        .overlay(alignment: .trailing) {
                            Image(systemName: "greaterthan")
                                .imageScale(.large)
                                .font(.title3)
                                .padding(.trailing,5)
                        }
                        .overlay(alignment: .topLeading) {
                            Text("Current Location")
                                .padding([.leading,.bottom],5)
                                .padding(.trailing,8)
                                .background(.black.opacity(0.33))
                                .clipShape(.rect(bottomTrailingRadius: 15))
                        }
                        .clipShape(.rect(cornerRadius: 15))
                    }
                    
                    // appear in
                    Text("Appears in:")
                        .font(.title)
                    
                    // id argument to solve error that String (movies is of type [String]) does not conform to Identifiable
                    ForEach(predator.movies, id: \.self) { movie in
                        Text("•" + movie)
                            .font(.subheadline)
                    }
                    
                    // movie moments
                    Text("Movie Moments")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding(.top,15)
                    
                    ForEach(predator.movie_scenes) { scene in
                        Text(scene.movie)
                            .font(.title2)
                            .padding(.vertical,1)
                        Text(scene.scene_description)
                            .padding(.bottom,15)
                        
                    }
                    
                    // link to web page
                    Text("Read more:")
                        .font(.caption)
                    
                    // urls are Optional by default (Swift is very particular about how to type urls) -> force unwrap to use
                    Link(predator.link, destination: URL(string: predator.link)!)
                        .font(.caption)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                }
                .padding()
                .padding(.bottom)
                .frame(width: geo.size.width, alignment: .leading)
                
            }
            .ignoresSafeArea()
            .toolbarBackground(.automatic)
        }
    }
}

#Preview {
    NavigationStack {
        // adding NavigationStackto preview so preview behaves more similarly to NavigationStack defined in ContentView
        PredatorDetail(predator: Predators().apexPredators[7], position: .camera(MapCamera(centerCoordinate: Predators().apexPredators[7].location, distance: 30000)))
            .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
    
    // add modifiers to Preview
}
