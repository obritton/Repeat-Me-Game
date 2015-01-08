//
//  RepeatMeGameController.swift
//  RepeatMeGame
//
//  Created by Ontario Britton on 1/5/15.
//  Copyright (c) 2015 Ontario Britton. All rights reserved.
//

import WatchKit
import Foundation

class RepeatMeGameController: WKInterfaceController {
    
    // MARK: - Variables & Constants
    let upperLeftAnimName = "upperLeftGlow"
    let upperRightAnimName = "upperRightGlow"
    let lowerLeftAnimName = "lowerLeftGlow"
    let lowerRightAnimName = "lowerRightGlow"
    let master = RepeatMeGameMaster()
    let delay = 0.5
    var isPlayingSequence = false
    
    // MARK: - Outlets
    @IBOutlet weak var upperLeftGroup: WKInterfaceGroup!
    @IBOutlet weak var upperRightGroup: WKInterfaceGroup!
    @IBOutlet weak var lowerLeftGroup: WKInterfaceGroup!
    @IBOutlet weak var lowerRightGroup: WKInterfaceGroup!
    
    // MARK: - Interface Management
    override init(context: AnyObject?) {
        // Initialize variables here.
        super.init(context: context)
        
        // Configure interface objects here.
        NSLog("%@ init", self)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ will activate", self)
        startNewGame()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        NSLog("%@ did deactivate", self)
        super.didDeactivate()
    }
    
    // MARK: - Button Actions
    @IBAction func pressedUpperLeft() {
        playQuadrantAnimation( upperLeftAnimName, group: upperLeftGroup )
        sendQuadrantTouch(.UpperLeft)
    }
    
    @IBAction func pressedLowerLeft() {
        playQuadrantAnimation( lowerLeftAnimName, group: lowerLeftGroup )
        sendQuadrantTouch(.LowerLeft)
    }
    
    @IBAction func pressedUpperRight() {
        playQuadrantAnimation( upperRightAnimName, group: upperRightGroup )
        sendQuadrantTouch(.UpperRight)
    }
    
    @IBAction func pressedLowerRight() {
        playQuadrantAnimation( lowerRightAnimName, group: lowerRightGroup )
        sendQuadrantTouch(.LowerRight)
    }
    
    // MARK: - Game Management
    func startNewGame()
    {
        let startingSequence = master.getStartingSequence()
        playSequenceAnimation(startingSequence)
    }
    
    func doLose(){
        popToRootController()
    }
    
    func sendQuadrantTouch( quadrant : Quadrant ){
        if !isPlayingSequence{
            let (continuePlaying,quadrantSequenceArray) = master.handleQuadrantTouch(quadrant)
            if( !continuePlaying){
                doLose()
            }
            else if( quadrantSequenceArray != nil){
                playSequenceAnimation(quadrantSequenceArray!)
            }
        }
    }
    
    // MARK: - Play Animations
    func playQuadrantAnimation( animBaseStr : String, group : WKInterfaceGroup ){
        group.setBackgroundImageNamed(animBaseStr)
        group.startAnimatingWithImagesInRange(NSMakeRange(0, 10), duration: 0.5, repeatCount: 1)
    }
    
    func playSequenceAnimation( sequence : [Quadrant] ){
        
        isPlayingSequence = true
        for var i = 0; i < sequence.count; ++i{
            let rawVal = sequence[i].rawValue
            let delay = 1 + 0.5*Double(i)
            NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: "playQuadrantAnimation:", userInfo: rawVal, repeats: false)
        }
        
        let delay = 0.5*Double(sequence.count)
        NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: "delayedSetIsPlayingSequenceFalse", userInfo: nil, repeats: false)
    }
    
    func playQuadrantAnimation( timer: NSTimer ){
        if let rawVal = timer.userInfo? as? Int{
            let quadrant = Quadrant(rawValue: rawVal)
            switch( quadrant! ){
            case .UpperLeft:
                playQuadrantAnimation(upperLeftAnimName, group: upperLeftGroup)
                break
            case .UpperRight:
                playQuadrantAnimation(upperRightAnimName, group: upperRightGroup)
                break
            case .LowerLeft:
                playQuadrantAnimation(lowerLeftAnimName, group: lowerLeftGroup)
                break
            case .LowerRight:
                playQuadrantAnimation(lowerRightAnimName, group: lowerRightGroup)
                break
            default:
                break
            }
        }
    }
    
    func delayedSetIsPlayingSequenceFalse(){
        isPlayingSequence = false
    }
}

