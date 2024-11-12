import SwiftUI
import MapboxMaps

extension Turf.JSONValue {
    func stringValue() -> String? {
        if case let .string(value) = self {
            return value
        }
        return nil
    }
}

struct MapboxMapView: UIViewRepresentable {
    let center: CLLocationCoordinate2D
    let styleURI: StyleURI
    @ObservedObject var gestureTokens: GestureTokens // Use the mutable tokens class
    @Binding var selectedFeature: GroomerLocation? // Binding for selected feature name

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
    
    struct GroomerLocation: Equatable {
        let storeName: String
        let address: String
        let city: String
        let postalCode: String
        let phoneFormatted: String?
    }

    private func setupLayerTapGesture(for mapView: MapView) {
        mapView.gestures.onLayerTap("dog-groomers-boston-marker1") { queriedFeature, _ in
            if let properties = queriedFeature.feature.properties {
               let selectedGroomerLocation = GroomerLocation(
                   storeName: (properties["storeName"] as? Turf.JSONValue)?.stringValue() ?? "",
                   address: (properties["address"] as? Turf.JSONValue)?.stringValue() ?? "",
                   city: (properties["city"] as? Turf.JSONValue)?.stringValue() ?? "",
                   postalCode: (properties["postalCode"] as? Turf.JSONValue)?.stringValue() ?? "",
                   phoneFormatted: (properties["phoneFormatted"] as? Turf.JSONValue)?.stringValue()
               )
                
                DispatchQueue.main.async {
                    selectedFeature = selectedGroomerLocation
                }
            }
            return true
        }.store(in: &gestureTokens.tokens)
    }

}

