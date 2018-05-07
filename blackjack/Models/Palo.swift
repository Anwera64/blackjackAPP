//
//  Palo.swift
//  blackjack
//
//  Created by Anton Tchistiakov on 5/4/18.
//  Copyright © 2018 Anton Tchistiakov. All rights reserved.
//

import Foundation

enum Palo: Int {
    case hearts = 0
    case diamonds = 1
    case spades = 2
    case clubs = 3
    
    func getString() -> String {
        switch self {
        case .hearts:
            return "Hearts"
        case .diamonds:
            return "Diamonds"
        case .spades:
            return "Spades"
        case .clubs:
            return "Clubs"
        }
    }
}
