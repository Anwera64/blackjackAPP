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
}

enum Player: String {
    case player = "Jugador"
    case house = "Casa"
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
        var suma = 0
        for carta in cartas {
            suma += carta.numero
            if suma > 21 {
                switch playerTurn {
                case .player:
                    delegate.endGame(winner: Player.house.rawValue)
                    break
                case .house:
                    delegate.endGame(winner: Player.player.rawValue)
                }
            }
        }
        if suma == 21 {
            delegate.endGame(winner: playerTurn.rawValue)
        }
    }
    
    func resetTurn() {
        playerTurn = .house
    }
}
