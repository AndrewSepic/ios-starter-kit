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

    var body: some View {
        let center = CLLocationCoordinate2D(latitude: 42.34942, longitude: -71.06403)
        let styleURI = StyleURI(rawValue: "mapbox://styles/examples/cm37hh1nx017n01qk2hngebzt") ?? .streets

        MapboxMapView(center: center, styleURI: styleURI, gestureTokens: gestureTokens)
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView()
}

