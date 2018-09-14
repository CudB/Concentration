//
//  ViewController.swift
//  Concentration
//
//  Created by Andy Au on 2018-07-06.
//  Copyright © 2018 Standford University. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2, numberOfThemes: emojiSets.count)

    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet var newGameButton: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    @IBAction func touchNewGameButton(_ sender: UIButton) {
        game.startNewGame(numberOfThemes: emojiSets.count)
        flipCount = 0
        emoji = [Int:String]()
        currentEmojiSet = emojiSets[game.theme]
        updateViewFromModel()
    }

    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    
    var emojiSets = [
        ["🎃","👻","😱","😈","🙀","🦇","🍭","🍎","🍬"],
        ["🏒","🎾","⚾️","🏈","⚽️","🏀","🏐","🏓","🏸"],
        ["🐀","🐂","🐅","🐇","🐉","🐍","🐎","🐐","🐒","🐓","🐕","🐖"],
        ["🚗","🚌","🏎","🚓","🚑","🚒","🚜","🚐","🚚"],
        ["🇨🇦","🇺🇸","🇨🇳","🇷🇺","🇬🇧","🇲🇽","🇦🇺","🇯🇵","🇰🇷"],
        ["😀","😂","☺️","🧐","😔","😡","🤔","🙄","😴"]
    ]

    lazy var currentEmojiSet = emojiSets[game.theme]
    
    var emoji = [Int:String]()
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, currentEmojiSet.count > 0 {
                let randomIndex = Int(arc4random_uniform(UInt32(currentEmojiSet.count)))
                emoji[card.identifier] = currentEmojiSet.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
}





