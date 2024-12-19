//
//  StarterKitHelpers.swift
//  Starter Kit
//
//  Created by Andrew Sepic on 12/19/24.
//

import MapboxMaps
import Turf

func flyToRandomFeature(
    mapView: MapView,
    sourceId: String,
    completion: @escaping (MapboxMapView.GroomerLocation?) -> Void
) {
    
    // Access Features
    mapView.mapboxMap.queryRenderedFeatures(
        with: mapView.bounds,
        options: RenderedQueryOptions(layerIds: [sourceId], filter: nil)
    ) { result in
        switch result {
        case .success(let queriedFeatures):
          // Process the queried features into your desired model
          let features = queriedFeatures.map { queriedFeature in
              // Convert QueriedRenderedFeature to Feature (this will depend on your specific model)
              return queriedFeature.queriedFeature
          }
          print("features", features)
          // Call the completion with the processed features
          //completion(features)
            
          // Randomly select a feature
           guard let randomFeature = features.randomElement() else {
               print("No features found")
               completion(nil)
               return
           }
            
            // Extract properties and location
            let properties = randomFeature.feature.properties ?? [:]
            let selectedGroomerLocation = MapboxMapView.GroomerLocation(
                storeName: (properties["storeName"] as? Turf.JSONValue)?.stringValue() ?? "",
                address: (properties["address"] as? Turf.JSONValue)?.stringValue() ?? "",
                city: (properties["city"] as? Turf.JSONValue)?.stringValue() ?? "",
                postalCode: (properties["postalCode"] as? Turf.JSONValue)?.stringValue() ?? "",
                phoneFormatted: (properties["phoneFormatted"] as? Turf.JSONValue)?.stringValue(),
                rating: (properties["rating"] as? Turf.JSONValue)?.number
            )
            
            // Fly to the feature's location
            if let coordinate = randomFeature.feature.geometry?.point?.coordinates {
                print("Flying to ", selectedGroomerLocation.storeName)
                let cameraOptions = CameraOptions(
                    center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude),
                    zoom: 14.0
                )
                mapView.camera.ease(to: cameraOptions, duration: 2.0)
            }
            // Return the selected feature
            completion(selectedGroomerLocation)
           
        case .failure(let error):
            print("Error querying features: \(error)")
            completion(nil)
        }
    }




}
