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
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet var newGameButton: [UIButton]!
    
    // Signals that a card has been touched and updates the view after the model makes any changes.
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    // Resets the view after the Concentration model reinitializes and selects and new theme.
    @IBAction func touchNewGameButton(_ sender: UIButton) {
        game.startNewGame(numberOfThemes: emojiSets.count)
        emoji = [Int:String]()
        currentEmojiSet = emojiSets[game.theme]
        updateViewFromModel()
    }

    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                // Make sure a flipped card has an assigned emoji and the correct background color.
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                // Make sure a unflipped card is blank and has the correct background color.
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
        flipCountLabel.text = "\(game.flipCount) Flips"
        scoreLabel.text = "Score: \(game.score)"
    }
    
    // An array containing various arrays of emojis.
    // Add a new array of emojis for more variation.
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
    
    // Generate and return an emoji for a card if has not already been assigned one.
    // Return "?" instead of an emoji if there aren't enough emojis available in a set.
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, currentEmojiSet.count > 0 {
                let randomIndex = Int(arc4random_uniform(UInt32(currentEmojiSet.count)))
                emoji[card.identifier] = currentEmojiSet.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
}





