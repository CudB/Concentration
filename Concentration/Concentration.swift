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
    
    var indexOfOneAndOnlyFaceUpCard: Int?
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
   
    // Sorts an array of type Card
    // Takes [Card] as an argument and mutates it
    func sortCards(cards: inout [Card]) {
        var sortedCards = [Card]()
        for _ in 1...cards.count {
            sortedCards += [cards.remove(at: Int(arc4random_uniform(UInt32(cards.count))))]
        }
        cards = sortedCards
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        sortCards(cards: &cards)
    }
}
