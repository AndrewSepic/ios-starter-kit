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
    var body: some View {
        let center = CLLocationCoordinate2D(
            latitude: 42.34942,
            longitude: -71.06403
          )
        // Attempt to create a StyleURI from the raw value, with a default fallback
        let styleURI = StyleURI(rawValue: "mapbox://styles/examples/cm37hh1nx017n01qk2hngebzt") ?? .streets
        
        return Map(initialViewport: .camera(
            center: center,
            zoom: 10.5
            )).mapStyle(MapStyle(uri: styleURI))
    }
}


#Preview {
    ContentView()
}
