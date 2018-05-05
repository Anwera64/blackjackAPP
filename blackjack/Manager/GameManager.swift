//
//  GameManager.swift
//  blackjack
//
//  Created by Anton Tchistiakov on 5/4/18.
//  Copyright © 2018 Anton Tchistiakov. All rights reserved.
//

import Foundation

protocol gameDelegate {
    func endGame(winner: String)
    func playerChange(newPlayer: Player)
    func updateCounter(number: Int)
}

enum Player: String {
    case player = "Jugador"
    case house = "Casa"
    
    func getOppositeValue() -> String {
        switch self {
        case .player:
            return Player.house.rawValue
        case .house:
            return Player.player.rawValue
        }
    }
}

class GameManager {
    
    var playerTurn: Player = .house {
        didSet {
            delegate.playerChange(newPlayer: playerTurn)
        }
    }
    
    private var cartasCasa: [Carta]! {
        didSet {
            check21(cartas: cartasCasa)
            if cartasCasa.count == 2 {
                playerTurn = .player
            }
        }
    }
    private var cartasJugador: [Carta]! {
        didSet {
            check21(cartas: cartasJugador)
            if cartasCasa.count == 4 {
                playerTurn = .house
            }
        }
    }
    private var delegate: gameDelegate!
    
    init(delegate: gameDelegate) {
        cartasCasa = Array()
        cartasJugador = Array()
        self.delegate = delegate
    }
    
    func pass() {
        if playerTurn == .house { return }
        playerTurn = .house
    }
    
    func addCard(carta c: Carta) {
        switch playerTurn {
        case .player:
            cartasJugador.append(c)
            break
        case .house:
            cartasCasa.append(c)
            break
        }
    }
    
    func check21(cartas: [Carta]) {
        let suma = count(cartas)
        if suma == 21 {
            delegate.endGame(winner: playerTurn.rawValue)
        } else if playerTurn == .house && !cartasJugador.isEmpty && suma > count(cartasJugador) {
            delegate.endGame(winner: playerTurn.rawValue)
        }
    }
    
    func count(_ cartas: [Carta]) -> Int {
        var suma: Int = 0
        for carta in cartas {
            suma += carta.numero
            if suma > 21 {
                switch playerTurn {
                case .player:
                    delegate.endGame(winner: playerTurn.getOppositeValue())
                    break
                case .house:
                    delegate.endGame(winner: playerTurn.getOppositeValue())
                }
            }
        }
        return suma
    }
    
    func resetTurn() {
        playerTurn = .house
        cartasCasa = Array()
        cartasJugador = Array()
    }
}
