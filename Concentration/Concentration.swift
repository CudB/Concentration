//
//  Concentration.swift
//  Concentration
//
//  Created by Andy Au on 2018-09-12.
//  Copyright © 2018 Standford University. All rights reserved.
//

import Foundation

class Concentration
{
    var cards = [Card]()
    var theme = Int()
    
    var indexOfOneAndOnlyFaceUpCard: Int?
    
    var flipCount = 0
    var score = 0
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // Flipping a second card.
                if cards[matchIndex].identifier == cards[index].identifier {
                    // Successful match; score incremented.
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                } else {
                    // Mismatch; score deduction if a card has already been seen.
                    if cards[matchIndex].hasBeenSeen == true {
                        score -= 1
                    }
                    if cards[index].hasBeenSeen == true {
                        score -= 1
                    }
                }
                cards[index].isFaceUp = true
                cards[index].hasBeenSeen = true
                cards[matchIndex].hasBeenSeen = true
                indexOfOneAndOnlyFaceUpCard = nil
                flipCount += 1
            } else if cards[index].isFaceUp == false {
                // Flipping the first card.
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
                flipCount += 1
            }
        }
    }
   
    // Sorts an array of type Card through mutation of the inout argument.
    func sortCards(cards: inout [Card]) {
        var sortedCards = [Card]()
        for _ in 1...cards.count {
            // Randomly removes a card from cards and adds it to sortedCards.
            sortedCards += [cards.remove(at: Int(arc4random_uniform(UInt32(cards.count))))]
        }
        cards = sortedCards
    }
    
    // Start a new game by reverting to initial game state, sorting all cards, and selecting a new theme at random.
    func startNewGame(numberOfThemes: Int) {
        theme = Int(arc4random_uniform(UInt32(numberOfThemes)))
        for index in 0..<cards.count {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
            cards[index].hasBeenSeen = false
        }
        sortCards(cards: &cards)
        indexOfOneAndOnlyFaceUpCard = nil
        flipCount = 0
        score = 0
    }
    
    init(numberOfPairsOfCards: Int, numberOfThemes: Int) {
        // Create a deck of paired cards.
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        startNewGame(numberOfThemes: numberOfThemes)
    }
}
