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
              
            let addressText = feature.address + ", " + feature.city + " " + feature.postalCode
                
            InfoRow(imageName: "building", text: addressText)
                
            PhoneRow(phone: feature.phoneFormatted ?? "N/A")

            Rating(rating: 2)
                .frame(maxWidth: .infinity, alignment: .leading)
        
                
              
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


struct InfoRow: View {
    let imageName: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.blue)
            Text(text)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

import SwiftUI

struct PhoneRow: View {
    let phone: String?

    var body: some View {
        HStack {
            Image(systemName: "phone.fill")
                .foregroundColor(.blue)
                .font(.system(size: 24))
            
            // Make the phone number text tappable
            Button(action: {
                if let phoneNumber = phone, let url = URL(string: "tel://\(phoneNumber)") {
                    UIApplication.shared.open(url)
                }
            }) {
                Text(phone ?? "N/A")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(PlainButtonStyle())  // Prevent default button styling (if you want to keep it consistent)
        }
    }
}


struct Rating: View {
    let rating: Int?
    
    var body: some View {
        HStack {
            Text("Rating: \(rating ?? 0)/5")
                .font(.subheadline)
                .bold()
            
            
            // Loop to generate rating images
            ForEach(0..<5, id: \.self) { index in
                if let rating = rating {
                    Image(systemName: "pawprint.fill")
                        .foregroundColor(index < rating ? .blue : .gray) // Color based on the rating
                        .font(.system(size: 24))
                       
                } else {
                    // Handle case when rating is nil, if necessary
                    Image(systemName: "pawprint.fill")
                        .foregroundColor(.gray) // Default to gray if rating is nil
                        .font(.system(size: 24))
                }
            }
        }
    }
}


