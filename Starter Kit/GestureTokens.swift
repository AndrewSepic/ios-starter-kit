//
//  GestureTokens.swift
//  Starter Kit
//
//  Created by Andrew Sepic on 11/8/24.
//

import Combine

class GestureTokens: ObservableObject {
    var tokens = Set<AnyCancellable>()
}
