//
//  ContentView.swift
//  Starter Kit
//
//  Created by Andrew Sepic on 11/8/24.
//

import SwiftUI
// The API may change in future releases.
@_spi(Experimental) import MapboxMaps

struct ContentView: View {
    @StateObject private var gestureTokens = GestureTokens()
    @State private var selectedFeature: MapboxMapView.GroomerLocation? = nil
    @State private var mapView: MapView? = nil

    var body: some View {
        let center = CLLocationCoordinate2D(
            latitude: 42.34622,
            longitude: -71.09290
        )
        let styleURI = StyleURI(rawValue: "mapbox://styles/examples/cm37hh1nx017n01qk2hngebzt") ?? .streets

        ZStack(alignment: .bottom) {
            MapboxMapView(
                center: center,
                styleURI: styleURI,
                gestureTokens: gestureTokens,
                selectedFeature: $selectedFeature,
                onMapViewCreated: { mapView in
                    self.mapView = mapView
                }
            )
            .ignoresSafeArea(.all)
            
            VStack(
                alignment: .leading,
                spacing: 10
            ) {
                HStack {
                    Button(action: {
                        if let mapView = mapView {
                            flyToRandomFeature(mapView: mapView, sourceId: "dog-groomers-boston-marker") { selected in
                                selectedFeature = selected
                            }
                        }
                    }) {
                        Text("Fly to a Groomer")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .controlSize(.mini) // Reduce button size
                    .padding() // Add padding to the top
                    Spacer()
                }
                Spacer()
            }
            
            if let feature = selectedFeature {
                   DrawerView(feature: feature) {
                       withAnimation {
                           selectedFeature = nil
                       }
                   }
                   .transition(.move(edge: .bottom))
               }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}


#Preview {
    ContentView()
}

