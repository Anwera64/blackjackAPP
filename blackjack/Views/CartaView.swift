//
//  CartaView.swift
//  blackjack
//
//  Created by Anton Tchistiakov on 5/4/18.
//  Copyright © 2018 Anton Tchistiakov. All rights reserved.
//

import UIKit

protocol onTouchDelegate {
    func onTouch(carta c: Carta)
}

class CartaView: UIView {
    
    private var carta: Carta?
    var delegate: onTouchDelegate?
    var volteada = false {
        didSet {
            for view in self.subviews {
                view.removeFromSuperview()
            }
            setNeedsDisplay()
        }
    }
    var tappable = false
    
    func removeTap() {
        tappable = false
    }
    
    func instantiate(_ carta: Carta, delegate: onTouchDelegate) {
        self.carta = carta
        self.delegate = delegate
        if volteada { self.volteada = false }
        let tapRecognizer: UIGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(voltear(_:)))
        addGestureRecognizer(tapRecognizer)
        tappable = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code\
        let origin = self.bounds.origin
        let size = self.bounds.size
        if volteada {
            let label = UILabel(frame: CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height))
            label.text = String(carta!.numero) + carta!.palo.getString()
            label.textAlignment = .center
            self.addSubview(label)
        } else {
            let cardBack = UIImageView(frame: CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height))
            cardBack.image = #imageLiteral(resourceName: "cardback")
            self.addSubview(cardBack)
        }
    }
    
    @objc
    func voltear(_ gestureRecognizer : UIGestureRecognizer? = nil) {
        if carta != nil && !volteada && tappable {
            volteada = !volteada
            delegate?.onTouch(carta: carta!)
        }
    }
    
    
}
