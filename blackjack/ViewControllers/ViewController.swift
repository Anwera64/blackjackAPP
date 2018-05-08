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
    var animator: UIViewPropertyAnimator!
    
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
        traverseCards(cardClosures: setCards, cardArray: cardsCollection)
        firstSteps()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        traverseCards(cardClosures: animateTransition, cardArray: cardsCollection)
    }
    
    private func firstSteps() {
        traverseCards(cardClosures: enableTap, cardArray: earlyHouseCards)
        traverseCards(cardClosures: enableTap, cardArray: earlyPlayerCards)
        for _ in 0...1 {
            traverseCards(cardClosures: tap, cardArray: gameManager.playerTurn == .house ? earlyHouseCards : earlyPlayerCards)
            gameManager.switchPLayer()
        }
    }
    
    func onTouch(carta: Carta) {
        gameManager.addCard(carta: carta)
    }
    
    func animateTransition(carta: CartaView) {
        carta.frame.origin.x -= view.frame.width
        animator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut, animations: {() -> Void in
                carta.frame.origin.x += self.view.frame.width
            })
        animator.startAnimation()
    }
    
    func tap(carta: CartaView) {
        carta.voltear()
    }
    
    func endGame(winner: String) {
        gameManager.endGame = true
        resultLabel.text = "Ganador: "+winner
        traverseCards(cardClosures: cancelTap, cardArray: cardsCollection)
    }
    
    private func setCards(carta: CartaView) {
        carta.instantiate(gameManager.getCard(), delegate: self)
    }
    
    private func cancelTap(carta: CartaView) {
        carta.removeTap()
    }
    
    private func enableTap(carta: CartaView) {
        carta.enableTap()
    }
    
    typealias CardClosure = (_ carta: CartaView) -> Void
    private func traverseCards(cardClosures: CardClosure..., cardArray: [CartaView]) {
        for carta in cardArray {
            for f in cardClosures {
                f(carta)
            }
        }
    }
    
    @IBAction func reset(_ sender: UIButton) {
        traverseCards(cardClosures: setCards, animateTransition, cardArray: cardsCollection)
        resultLabel.text = ""
        gameManager.resetTurn()
        firstSteps()
    }
    
    @IBAction func pass(_ sender: UIButton) {
        gameManager.pass()
    }
    
    func playerChange(newPlayer: Player) {
        traverseCards(cardClosures: cancelTap, cardArray: newPlayer == .house ? playerCards : houseCards)
        traverseCards(cardClosures: enableTap, cardArray: newPlayer == .house ? houseCards : playerCards)
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
        traverseCards(cardClosures: tap, cardArray: houseCards)
    }
}

