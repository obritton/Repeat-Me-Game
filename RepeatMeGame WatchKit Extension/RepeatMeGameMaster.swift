//
//  RepeatMeGameMaster.swift
//  RepeatMeGame
//
//  Created by Ontario Britton on 1/6/15.
//  Copyright (c) 2015 Ontario Britton. All rights reserved.
//

import Foundation

enum Quadrant : Int {
    case UpperRight, LowerRight, LowerLeft, UpperLeft
    
    static func getRandomValue() -> Quadrant{
        let randomValue = Int(arc4random()%4)
        return self(rawValue: randomValue)!
    }
}

class RepeatMeGameMaster {
    
    var quadrantSequenceArr : [Quadrant] = []
    var accumulatedSequenceArr : [Quadrant] = []
    
    func getStartingSequence() -> [Quadrant]{
        quadrantSequenceArr.removeAll(keepCapacity: false)
        accumulatedSequenceArr.removeAll(keepCapacity: false)
        addNextQuadrantToSequence()
        addNextQuadrantToSequence()
        addNextQuadrantToSequence()
        return quadrantSequenceArr
    }
    
    //This method returns true if the game continues past this Quadrant touch
    //  Returns false if this quadrant touch causes this player to lose
    func handleQuadrantTouch( quadrant : Quadrant ) -> (Bool, [Quadrant]?) {
        accumulatedSequenceArr.append(quadrant)
        
        var doArraysMatch = matchArraysFromBeginning(quadrantSequenceArr, sequence2: accumulatedSequenceArr)
        var isAccumulationComplete = quadrantSequenceArr.count == accumulatedSequenceArr.count
        var returnArr : [Quadrant]? = nil
        
        if( isAccumulationComplete ){
            resetTurn()
            returnArr = quadrantSequenceArr
        }
        
        return (doArraysMatch,returnArr)
    }
    
    func resetTurn()
    {
        addNextQuadrantToSequence()
        accumulatedSequenceArr.removeAll(keepCapacity: false)
    }
    
    //This method checks that two arrays of different lengths have the same values
    //  In the range of the shorter array
    func matchArraysFromBeginning( sequence1 : [Quadrant], sequence2 : [Quadrant] ) -> Bool{
        
        let count = sequence1.count < sequence2.count ? sequence1.count : sequence2.count
        for var i = 0; i < count; ++i{
            if sequence1[i] != sequence2[i]{
                return false;
            }
        }
        
        return true
    }
    
    func addNextQuadrantToSequence(){
        let newQuadrant = Quadrant.getRandomValue()
        quadrantSequenceArr.append(newQuadrant)
    }
}