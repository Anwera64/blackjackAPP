//
//  ViewController.swift
//  blackjack
//
//  Created by Anton Tchistiakov on 5/4/18.
//  Copyright © 2018 Anton Tchistiakov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, onTouchDelegate, gameDelegate {
    
    @IBOutlet weak var resultLabel: UILabel!
    var gameManager: GameManager!
    
    @IBOutlet var cardsCollection: [CartaView]!
    @IBOutlet var playerCards: [CartaView]!
    @IBOutlet var houseCards: [CartaView]!
    @IBOutlet var earlyHouseCards: [CartaView]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gameManager = GameManager(delegate: self)
        firstSteps()
    }
    
    private func firstSteps() {
        traverseCards(function: setCards, cardArray: playerCards)
        showTwoHouseCards()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onTouch(carta: Carta) {
        gameManager.addCard(carta: carta)
    }
    
    func showTwoHouseCards() {
        var counter = 1
        for carta in earlyHouseCards {
            carta.instantiate(Carta(10, .hearts), delegate: self)
            carta.voltear()
            counter += 1
            if counter > 2 { break }
        }
    }
    
    func endGame(winner: String) {
        resultLabel.text = "Ganador: "+winner
        traverseCards(function: cancelTap, cardArray: cardsCollection)
    }
    
    private func setCards(carta: CartaView) {
        carta.instantiate(Carta(10, .hearts), delegate: self)
    }
    
    private func cancelTap(carta: CartaView) {
        carta.removeTap()
    }
    
    private func traverseCards(function: (_ carta: CartaView) -> Void, cardArray: [CartaView]) {
        for carta in cardArray {
            function(carta)
        }
    }
    
    @IBAction func reset(_ sender: UIButton) {
        traverseCards(function: cancelTap, cardArray: cardsCollection)
        resultLabel.text = ""
        gameManager.resetTurn()
        firstSteps()
    }
    
    @IBAction func pass(_ sender: UIButton) {
        gameManager.pass()
    }
    
    func playerChange(newPlayer: Player) {
        traverseCards(function: cancelTap, cardArray: newPlayer == .house ? playerCards : houseCards)
        traverseCards(function: setCards, cardArray: newPlayer == .house ? houseCards : playerCards)
    }
}

