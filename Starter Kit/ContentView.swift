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
    @StateObject private var gestureTokens = GestureTokens() // Mutable storage for tokens
    @State private var selectedFeature: MapboxMapView.GroomerLocation? = nil


    var body: some View {
        let center = CLLocationCoordinate2D(
            latitude: 42.34622,
            longitude: -71.09290
          )
        let styleURI = StyleURI(rawValue: "mapbox://styles/examples/cm37hh1nx017n01qk2hngebzt") ?? .streets

        ZStack(alignment: .bottom) {
            // 1. Background layer: The Mapbox map view
            MapboxMapView(center: center, styleURI: styleURI, gestureTokens: gestureTokens, selectedFeature: $selectedFeature)
                .ignoresSafeArea(.all)
                
            
            // 2. Foreground layer: The drawer view, which will appear above the map
            if let feature = selectedFeature {
                DrawerView(feature: feature) {
                    withAnimation {
                        selectedFeature = nil
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

