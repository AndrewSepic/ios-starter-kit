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

// TODO - Remove scale & compass on map

struct MapboxMapView: UIViewRepresentable {
    let center: CLLocationCoordinate2D
    let styleURI: StyleURI
    @ObservedObject var gestureTokens: GestureTokens // Use the mutable tokens class
   @Binding var selectedFeature: GroomerLocation? // Binding for selected feature name
  
    func makeUIView(context: Context) -> MapView {
        let mapInitOptions = MapInitOptions(
            cameraOptions: CameraOptions(center: center, zoom: 8.5),
            styleURI: styleURI
        )
        let mapView = MapView(frame: .zero, mapInitOptions: mapInitOptions)
        
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
        let rating: Double?
    }

    private func setupLayerTapGesture(for mapView: MapView) {
        mapView.gestures.onLayerTap("dog-groomers-boston-marker") { queriedFeature, _ in
            if let properties = queriedFeature.feature.properties {
               let selectedGroomerLocation = GroomerLocation(
                   storeName: (properties["storeName"] as? Turf.JSONValue)?.stringValue() ?? "",
                   address: (properties["address"] as? Turf.JSONValue)?.stringValue() ?? "",
                   city: (properties["city"] as? Turf.JSONValue)?.stringValue() ?? "",
                   postalCode: (properties["postalCode"] as? Turf.JSONValue)?.stringValue() ?? "",
                   phoneFormatted: (properties["phoneFormatted"] as? Turf.JSONValue)?.stringValue(),
                   rating: (properties["rating"] as? Turf.JSONValue)?.number
               )
                
              
                // Use self.selectedFeature since selectedFeature is a @Binding passed down from the parent view
                self.selectedFeature = selectedGroomerLocation
            
            }
            return true
        }.store(in: &gestureTokens.tokens)
    }

}

