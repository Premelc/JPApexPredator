//
//  ContentView.swift
//  JPApexPredators
//
//  Created by Dominik Premelč on 15.07.2025..
//

import SwiftUI
import MapKit

struct ContentView: View {
    let predators = Predators()
    @State var searchText = ""
    @State var alphabetical = false
    @State var currentSelection = APType.all
    
    var filteredDinos: [ApexPredator]{
        predators.filter(by: currentSelection)
        predators.sort(by: alphabetical)
        return predators.search(for: searchText)
    }
    
    var body: some View {
        NavigationStack{
        List(filteredDinos) { predator in
            NavigationLink{
                PredatorDetail(predator: predator,
                               position: .camera(MapCamera(centerCoordinate: predator.location, distance: 30000)))
            } label:{
                HStack {
                    Image(predator.image).resizable().scaledToFit().frame(width: 100, height: 100).shadow(color: .white,radius: 1)
                    VStack(alignment: .leading){
                        Text(predator.name)
                            .fontWeight(.bold)
                        
                        Text(predator.type.rawValue.capitalized)
                            .fontWeight(.semibold)
                            .padding(.horizontal , 13)
                            .padding(.vertical , 5)
                            .background(predator.type.background)
                            .clipShape(.capsule)
                    }
                }
            }
            }
        .navigationTitle("Apex predators")
        .searchable(text: $searchText)
        .autocorrectionDisabled()
        .animation(.default , value: searchText)
        .toolbar{
            ToolbarItem(placement: .topBarLeading){
                Button{
                    withAnimation{
                        alphabetical.toggle()
                    }
                } label: {
                    Image(systemName: alphabetical ? "textformat" : "film").symbolEffect(.bounce, value: alphabetical)
                }
            }
            ToolbarItem(placement: .topBarTrailing){
                Menu{
                    Picker(
                        "Filter",
                        selection: $currentSelection.animation()
                    ) {
                        ForEach(APType.allCases) { type in
                            Label(type.rawValue.capitalized, systemImage: type.icon)
                        }
                    }
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
            }
        }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
 
