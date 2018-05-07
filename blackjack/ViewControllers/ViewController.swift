//
//  ViewController.swift
//  blackjack
//
//  Created by Anton Tchistiakov on 5/4/18.
//  Copyright © 2018 Anton Tchistiakov. All rights reserved.
//

import UIKit
import Darwin

class ViewController: UIViewController, onTouchDelegate, gameDelegate {
    
    @IBOutlet weak var resultLabel: UILabel!
    var gameManager: GameManager!
    
    @IBOutlet var cardsCollection: [CartaView]!
    @IBOutlet var playerCards: [CartaView]!
    @IBOutlet var houseCards: [CartaView]!
    @IBOutlet var earlyHouseCards: [CartaView]!
    @IBOutlet var earlyPlayerCards: [CartaView]!
    
    @IBOutlet weak var houseLabel: UILabel!
    @IBOutlet weak var playerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gameManager = GameManager(delegate: self)
        traverseCards(function: setCards, cardArray: cardsCollection)
        firstSteps()
    }
    
    private func firstSteps() {
        traverseCards(function: enableTap, cardArray: earlyHouseCards)
        traverseCards(function: enableTap, cardArray: earlyPlayerCards)
        for _ in 0...1 {
            traverseCards(function: tap, cardArray: gameManager.playerTurn == .house ? earlyHouseCards : earlyPlayerCards)
            gameManager.switchPLayer()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onTouch(carta: Carta) {
        gameManager.addCard(carta: carta)
    }
    
    func tap(carta: CartaView) {
        carta.voltear()
    }
    
    func endGame(winner: String) {
        resultLabel.text = "Ganador: "+winner
        traverseCards(function: cancelTap, cardArray: cardsCollection)
    }
    
    private func createRandomCard() -> Carta {
        return Carta(Int(arc4random_uniform(13)+1), Palo(rawValue: Int(arc4random_uniform(4)))!)
    }
    
    private func setCards(carta: CartaView) {
        carta.instantiate(createRandomCard(), delegate: self)
    }
    
    private func cancelTap(carta: CartaView) {
        carta.removeTap()
    }
    
    private func enableTap(carta: CartaView) {
        carta.enableTap()
    }
    
    private func traverseCards(function: (_ carta: CartaView) -> Void, cardArray: [CartaView]) {
        for carta in cardArray {
            function(carta)
        }
    }
    
    @IBAction func reset(_ sender: UIButton) {
        traverseCards(function: setCards, cardArray: cardsCollection)
        resultLabel.text = ""
        gameManager.resetTurn()
        firstSteps()
    }
    
    @IBAction func pass(_ sender: UIButton) {
        gameManager.pass()
    }
    
    func playerChange(newPlayer: Player) {
        traverseCards(function: cancelTap, cardArray: newPlayer == .house ? playerCards : houseCards)
        traverseCards(function: enableTap, cardArray: newPlayer == .house ? houseCards : playerCards)
    }
    
    func updateCounter(number: Int) {
        switch gameManager.playerTurn {
        case .player:
            playerLabel.text = "Jugador: \(number)"
        case .house:
            houseLabel.text = "Casa: \(number)"
        }
    }
    
    func playHouseCard(index: Int) {
        tap(carta: houseCards[index])
    }
    
    func revealHouseCards() {
        traverseCards(function: enableTap, cardArray: houseCards)
        traverseCards(function: tap, cardArray: houseCards)
    }
}

