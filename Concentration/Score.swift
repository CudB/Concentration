//
//  Score.swift
//  Concentration
//
//  Created by Andy Au on 2018-09-14.
//  Copyright © 2018 Standford University. All rights reserved.
//

import Foundation

class Score
{
    var startingScore: Int
    lazy var value = startingScore
    
    func resetScore() {
        value = startingScore
    }
    
    func increaseScore(by amountIncreased: Int = 1) {
        value += amountIncreased
    }
    
    func decreaseScore(by amountDecreased: Int = 1) {
        value -= amountDecreased
    }
    
    init(startingScore: Int = 0) {
        self.startingScore = startingScore
    }
}
