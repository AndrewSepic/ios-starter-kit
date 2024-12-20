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
    @State private var hasInteracted = false
    
    // Hold a strong reference to the gesture delegate
    @State private var gestureDelegate: GestureManagerDelegateImplementation?


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
                    // Create and retain the gesture delegate
                   let delegate = GestureManagerDelegateImplementation { gestureType in
                       DispatchQueue.main.async {
                           self.hasInteracted = true
                       }
                   }
                   
                   // Assign the gesture delegate
                   mapView.gestures.delegate = delegate
                   self.gestureDelegate = delegate // Retain the delegate strongly
                    
                })
            .ignoresSafeArea(.all)
            
            VStack(
                alignment: .leading,
                spacing: 10
            ) {
                HStack {
                    if hasInteracted { // Only show button if interacted
                        Button( action: {
                            mapView?.camera.fly(to: CameraOptions(
                                center: center,
                                zoom: 8.5,
                                bearing: 0,
                                pitch: 0
                            ), duration: 5.0)
                        }) {
                            Text("Reset Map")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .controlSize(.mini) // Reduce button size
                        .padding() // Add padding to the top
                        Spacer()
                    }
                
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

// GestureManagerDelegate Implementation
class GestureManagerDelegateImplementation: NSObject, GestureManagerDelegate {
    var onGestureBegin: (GestureType) -> Void
    
    init(onGestureBegin: @escaping (GestureType) -> Void) {
        self.onGestureBegin = onGestureBegin
    }
    
    func gestureManager(_ gestureManager: GestureManager, didBegin gestureType: GestureType) {
        // Notify when a gesture begins
        onGestureBegin(gestureType)
        print("\(gestureType) didBegin")
    }

    func gestureManager(_ gestureManager: GestureManager, didEnd gestureType: GestureType, willAnimate: Bool) {
        print("\(gestureType) didEnd")
    }

    func gestureManager(_ gestureManager: GestureManager, didEndAnimatingFor gestureType: GestureType) {
        print("didEndAnimatingFor \(gestureType)")
    }
}


#Preview {
    ContentView()
}

