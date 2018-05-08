//
//  Carta.swift
//  blackjack
//
//  Created by Anton Tchistiakov on 5/4/18.
//  Copyright © 2018 Anton Tchistiakov. All rights reserved.
//

import Foundation

class Carta: Hashable {
    var hashValue: Int {
        return (numero+palo.rawValue).hashValue
    }
    
    static func == (lhs: Carta, rhs: Carta) -> Bool {
        if lhs.hashValue == rhs.hashValue {
            return true
        } else {
            return false
        }
    }
    
    var numero: Int!
    var palo: Palo!
    
    init(_ numero: Int, _ palo: Palo) {
        self.numero = numero
        self.palo = palo
    }
}
