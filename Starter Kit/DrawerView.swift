//
//  DrawerView.swift
//  Starter Kit
//
//  Created by Andrew Sepic on 11/11/24.
//

import Foundation
import SwiftUI
import Turf

extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}

struct DrawerView: View {
    let feature: MapboxMapView.GroomerLocation
    var onDismiss: () -> Void
    
    // State for the feature dictionary, used for animation
    @State private var animatedFeature: MapboxMapView.GroomerLocation?

    var body: some View {
        VStack {
            Spacer() // Push drawer to bottom
            
            VStack(spacing: 16) {
              Text((feature.storeName))
                  .font(.headline)
                
              
            HStack {
                Image(systemName: "building")
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                Text(feature.address + ", " + feature.city + " " + feature.postalCode)
                    .font(.subheadline)
            }

              
              if let phone = feature.phoneFormatted {
                  
                  HStack {
                      Image(systemName: "phone.fill")
                          .foregroundColor(.blue)
                          .font(.system(size: 24))
                       Text(phone)
                           .font(.subheadline)
                  }
                 
              } else {
                  HStack {
                      Image(systemName: "phone.fill")
                          .foregroundColor(.blue)
                          .font(.system(size: 24))
                       Text(" N/A")
                           .font(.subheadline)
                  }
              }
                
                Text("Rating:")
                    .font(.subheadline)
                
                HStack {
                  Image(systemName: "pawprint.fill")
                      .foregroundColor(.blue)
                      .font(.system(size: 24))
                  Image(systemName: "pawprint.fill")
                      .foregroundColor(.blue)
                      .font(.system(size: 24))
                  Image(systemName: "pawprint.fill")
                      .foregroundColor(.blue)
                      .font(.system(size: 24))
                  Image(systemName: "pawprint.fill")
                      .foregroundColor(.blue)
                      .font(.system(size: 24))
                  Image(systemName: "pawprint.fill")
                      .foregroundColor(.grey)
                      .font(.system(size: 24))
                }
                
              
              Button("Close") {
                  onDismiss()
              }
              .padding(.top, 16)
          }
            .padding()
            .frame(maxWidth: .infinity) // This makes the drawer full width
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)
            .transition(.move(edge: .bottom))
            .onAppear {
                    // Initialize animatedFeature onAppear
                    animatedFeature = feature
                }
            .onChange(of: feature) { oldFeature, newFeature in
                    // Trigger animation when feature changes
                    withAnimation(.easeInOut) {
                        animatedFeature = newFeature
                    }
                }
                .animation(.easeInOut, value: animatedFeature) // Animate based on changes to animatedFeature
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    ContentView()
}
