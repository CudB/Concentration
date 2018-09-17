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
    private(set) var cards = [Card]()
    private(set) var theme = Int()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    private(set) var flipCount = 0
    private(set) var score = Score()
    private var currentDateTime = Date()
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // Flipping a second card.
                if cards[matchIndex].identifier == cards[index].identifier {
                    // Successful match; score incremented.
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score.increaseScore(by: 20 + Int(currentDateTime.timeIntervalSinceNow)) // Increase score by 20 with a deduction of 1 point per second elapsed
                    currentDateTime = Date()
                } else {
                    // Mismatch; score deduction if a card has already been seen.
                    if cards[matchIndex].hasBeenSeen == true {
                        score.decreaseScore(by: 5)
                    }
                    if cards[index].hasBeenSeen == true {
                        score.decreaseScore(by: 5)
                    }
                }
                cards[index].isFaceUp = true
                cards[index].hasBeenSeen = true
                cards[matchIndex].hasBeenSeen = true
                flipCount += 1
            } else if cards[index].isFaceUp == false {
                // Flipping the first card.
                indexOfOneAndOnlyFaceUpCard = index
                flipCount += 1
            }
        }
    }
   
    // Sorts an array of type Card through mutation of the inout argument.
    private func sortCards(cards: inout [Card]) {
        var sortedCards = [Card]()
        for _ in 1...cards.count {
            // Randomly removes a card from cards and adds it to sortedCards.
            sortedCards += [cards.remove(at: Int(arc4random_uniform(UInt32(cards.count))))]
        }
        cards = sortedCards
    }
    
    // Start a new game by reverting to initial game state, sorting all cards, and selecting a new theme at random.
    func startNewGame(numberOfThemes: Int) {
        assert(numberOfThemes > 0, "Concentration.startNewGame(numberOfThemes: \(numberOfThemes): you must have at least one theme")
        theme = Int(arc4random_uniform(UInt32(numberOfThemes)))
        for index in 0..<cards.count {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
            cards[index].hasBeenSeen = false
        }
        sortCards(cards: &cards)
        flipCount = 0
        score.resetScore()
        currentDateTime = Date()
    }
    
    init(numberOfPairsOfCards: Int, numberOfThemes: Int) {
        // Create a deck of paired cards.
        assert(numberOfPairsOfCards > 0, "Concentration.init(numberOfPairsOfCards: \(numberOfPairsOfCards): you must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        startNewGame(numberOfThemes: numberOfThemes)
    }
}
