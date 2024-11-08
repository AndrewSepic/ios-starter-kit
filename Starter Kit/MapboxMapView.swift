import SwiftUI
import MapboxMaps

struct MapboxMapView: UIViewRepresentable {
    let center: CLLocationCoordinate2D
    let styleURI: StyleURI
    @ObservedObject var gestureTokens: GestureTokens // Use the mutable tokens class

    func makeUIView(context: Context) -> MapView {
        let mapInitOptions = MapInitOptions(
            styleURI: styleURI
        )
        let mapView = MapView(frame: .zero, mapInitOptions: mapInitOptions)
        
        // Center the map on initialization
        mapView.camera.ease(to: CameraOptions(center: center, zoom: 10.5), duration: 0.5)
        
        // Set up tap gesture handling on the layer
        setupLayerTapGesture(for: mapView)
        
        return mapView
    }

    func updateUIView(_ uiView: MapView, context: Context) {
        // Any updates if needed
    }
    
    private func setupLayerTapGesture(for mapView: MapView) {
        // Handle taps on the specified layer
        mapView.gestures.onLayerTap("dog-groomers-boston-23w4aa") { feature, context in
            print("Tap on dog groomers feature \(feature) at \(context.coordinate)")
            return true
        }
        .store(in: &gestureTokens.tokens)
    }
}

