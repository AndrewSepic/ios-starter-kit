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

    @State private var animatedFeature: MapboxMapView.GroomerLocation?

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                VStack(spacing: 16) {
                    Text((feature.storeName))
                        .font(.title)
                        .padding(.vertical, 16)
                    
                    let addressText = feature.address + ", " + feature.city + " " + feature.postalCode
                    
                    InfoRow(imageName: "building", text: addressText)
                    
                    PhoneRow(phone: feature.phoneFormatted ?? "N/A")
                    
                    Rating(rating: feature.rating)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Remove the 'Close' button from the bottom
                    // The close button is now in the top-right corner
                    
                }
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 32, trailing: 20))
                .frame(maxWidth: .infinity)
                .background(
                    Color.white
                        .ignoresSafeArea(.all)
                )
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
            //            .border(Color.red, width: 2) // highlight used to see computed view
            
            closeButton
        }
    }
   
    // Close button in top-right corner
    var closeButton: some View {
        Button(action: {
              withAnimation {
                  onDismiss()
              }
          }) {
              Image(systemName: "xmark.circle.fill")
                  .foregroundColor(.gray)
                  .font(.system(size: 24))
                  .padding()
          }
          .padding(.top, 0) // Adds some space from the top of the screen
          .padding(.trailing, 0) // Adds some space from the right of the screen
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
                .font(.system(size: 16))
            
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
    let rating: Double?
    
    var body: some View {
        
        HStack {
            // safely unwrap rating to a string representing the number
            Text("Rating: \(rating.map { String(format: "%.1f", $0) } ?? "0")")
                .font(.subheadline)
                .bold()
            
            
            // Loop to generate rating images
            ForEach(0..<5, id: \.self) { index in
                if let rating = rating {
                    // Round the rating to the nearest whole number
                    let roundedRating = Int(rating.rounded())
                    Image(systemName: "pawprint.fill")
                        .foregroundColor(index < roundedRating ? .blue : .gray) // Color based on the rating
                        .font(.system(size: 16))
                       
                } else {
                    // Handle case when rating is nil, if necessary
                    Image(systemName: "pawprint.fill")
                        .foregroundColor(.gray) // Default to gray if rating is nil
                        .font(.system(size: 16))
                }
            }
        }
    }
}


