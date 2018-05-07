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
    func playHouseCard(index: Int)
    func revealHouseCards()
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
    
    func getOppositeType() -> Player {
        switch self {
        case .player:
            return Player.house
        case .house:
            return Player.player
        }
    }
}

class GameManager {
    
    var playerTurn: Player = .player {
        didSet {
            if endGame { return }
            delegate.playerChange(newPlayer: playerTurn)
            if passed, playerTurn == .house {
                delegate.revealHouseCards()
            } else if cartasJugador.count > 2, playerTurn == .house, !resetting {
                delegate.playHouseCard(index: cartasCasa.count - 2)
            }
        }
    }
    
    var passed = false
    var resetting = false
    var endGame = false
    
    private var cartasCasa: [Carta]! {
        didSet {
            check21(cartas: cartasCasa)
        }
    }
    private var cartasJugador: [Carta]! {
        didSet {
            check21(cartas: cartasJugador)
        }
    }
    private var delegate: gameDelegate!
    
    init(delegate: gameDelegate) {
        cartasCasa = Array()
        cartasJugador = Array()
        self.delegate = delegate
    }
    
    func switchPLayer() {
        playerTurn = playerTurn.getOppositeType()
    }
    
    func pass() {
        passed = true
        if playerTurn == .house { return }
        switchPLayer()
    }
    
    func addCard(carta c: Carta) {
        switch playerTurn {
        case .player:
            cartasJugador.append(c)
        case .house:
            cartasCasa.append(c)
        }
        if (playerTurn == .house ? cartasCasa : cartasJugador).count > 2, !passed {
            switchPLayer()
        }
    }
    
    func check21(cartas: [Carta]) {
        let suma = count(cartas)
        delegate.updateCounter(number: suma)
        if suma > 21 { return }
        if suma == 21 {
            delegate.endGame(winner: playerTurn.rawValue)
        } else if cartasCasa.count == 4, !resetting {
            let otherScore = count(playerTurn == .house ? cartasJugador : cartasCasa)
            if suma > otherScore {
                delegate.endGame(winner: playerTurn.rawValue)
            } else if suma < otherScore {
                delegate.endGame(winner: playerTurn.getOppositeValue())
            } else if suma == otherScore {
                delegate.endGame(winner: "Nadie. Es un empate")
            }
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
                case .house:
                    delegate.endGame(winner: playerTurn.getOppositeValue())
                }
            }
        }
        return suma
    }
    
    func resetTurn() {
        passed = false
        resetting = true
        endGame = false
        playerTurn = .house
        cartasCasa.removeAll()
        playerTurn = .player
        cartasJugador.removeAll()
        resetting = false
    }
}
