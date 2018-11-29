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
    // Overrides the default UI colors to match the selected theme when the app is loaded.
    override func viewDidLoad() {
        updateViewFromModel()
    }

    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards, numberOfThemes: themeSets.count)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private var newGameButton: [UIButton]!
    
    // Signals that a card has been touched and updates the view after the model makes any changes.
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    // Resets the view after the Concentration model reinitializes and selects and new theme.
    @IBAction private func touchNewGameButton(_ sender: UIButton) {
        game.startNewGame(numberOfThemes: themeSets.count)
        emoji = [Card:String]()
        currentTheme = themeSets[game.theme]
        updateViewFromModel()
    }

    private func updateViewFromModel() {
        view.backgroundColor = currentTheme.BGColor
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                // Make sure a flipped card has an assigned emoji and the correct background color.
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                // Make sure a unflipped card is blank and has the correct background color.
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : currentTheme.cardColor
            }
        }
        updateFlipCountLabel()
        scoreLabel.text = "Score: \(game.score.value)"
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "\(game.flipCount) Flips", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    // An array containing various themes.
    // Add or change a theme entry to customize.
    private let themeSets = [
        Theme(cardColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), BGColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), emojiSet: "🎃👻😱😈🙀🦇🍭🍎🍬"),
        Theme(cardColor: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), BGColor: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), emojiSet: "🏒🎾⚾️🏈⚽️🏀🏐🏓🏸"),
        Theme(cardColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), BGColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), emojiSet: "🐀🐂🐅🐇🐉🐍🐎🐐🐒🐓🐕🐖"),
        Theme(cardColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), BGColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), emojiSet: "🚗🚌🏎🚓🚑🚒🚜🚐🚚"),
        Theme(cardColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), BGColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), emojiSet: "🇨🇦🇺🇸🇨🇳🇷🇺🇬🇧🇲🇽🇦🇺🇯🇵🇰🇷"),
        Theme(cardColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), BGColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), emojiSet: "😀😂☺️🧐😔😡🤔🙄😴")
    ]

    private lazy var currentTheme = themeSets[game.theme]
    
    private var emoji = [Card:String]()
    
    // Generate and return an emoji for a card if has not already been assigned one.
    // Return "?" instead of an emoji if there aren't enough emojis available in a set.
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, currentTheme.emojiSet.count > 0 {
            let randomStringIndex = currentTheme.emojiSet.index(currentTheme.emojiSet.startIndex
                , offsetBy: currentTheme.emojiSet.count.arc4random)
                emoji[card] = String(currentTheme.emojiSet.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
}





