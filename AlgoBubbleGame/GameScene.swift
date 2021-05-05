//
//  GameScene.swift
//  AlgoBubbleGame
//
//  Created by Mario Fernandes on 17/04/2021.
//

import Foundation
import Combine
import SwiftUI
import SpriteKit




class GameScene: SKScene, ObservableObject {
    
    @Binding var horseAsset: Bool
    
    init(horseAsset: Binding<Bool>) {
        _horseAsset = horseAsset
        super.init(size: CGSize(width: 400, height: 800))
        self.scaleMode = .fill
      }
        
      required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
      }

    
   var theAssetState:bubbleGame = bubbleGame()
    
    
    var assetBubbleIsShowing = false
    
    let defaults:UserDefaults = UserDefaults.standard
    

    var timerLabel:SKLabelNode = SKLabelNode(fontNamed: "Arial")
    var bubbleLabel:SKLabelNode = SKLabelNode(fontNamed: "Arial")
    var totalBubbleLabel:SKLabelNode = SKLabelNode(fontNamed: "Arial")
    var ruleLabel:SKLabelNode = SKLabelNode(fontNamed: "Arial")
    
    
    var int = 0
    var nrOfBubbles = 5
    var number = 0
    var randomCount = Int.random(in: 1...3) + 1
    private var lastUpdateTime : TimeInterval = 0
    
    let background = SKSpriteNode(imageNamed: "bubbleBack")
    let timerCount = SKSpriteNode(imageNamed: "timerCount")
    let bubbleCount = SKSpriteNode(imageNamed: "bubbles")
    let totalBubbleCount = SKSpriteNode(imageNamed: "totalbubbles")
    let play: SKSpriteNode = SKSpriteNode(imageNamed: "play")

    var arrplayer :[SKSpriteNode] = [SKSpriteNode]()
    var playerNameArr = [String]()
    var theTimer = Timer()
    var secondsLeft = 15
    var startTime = 0
    var bubblesCatch = 0
    var totalBubblesCatch = 0
    
    // -------music//
    let musicNode = SKAudioNode(fileNamed: "PoolParty.wav")

    override func didMove(to view: SKView) {
        
        
        musicNode.autoplayLooped = true
        musicNode.isPositional = false
        // Add the audio the scene
        addChild(musicNode)

        self.lastUpdateTime = 0
        
        if defaults.object(forKey: "increaseTime") != nil {
            
            startTime = defaults.integer(forKey: "increaseTime")
            print(startTime)
            
        }else  {
            
            startTime = secondsLeft
            print(startTime)
        }
        
       
        
        setupStartButton()
        

        
        background.position = CGPoint(x: 0, y: 0)
        background.name = "background"
        addChild(background)
        
        
       
        timerCount.position = CGPoint(x: -130, y: 80)
        timerCount.zPosition = 90
        timerCount.name = "timerCount"
        addChild(timerCount)
        

        timerLabel.text = "\(startTime)"
        timerLabel.fontSize = 24
       
        timerLabel.fontColor = SKColor.white
        timerLabel.horizontalAlignmentMode = .left
        timerLabel.position = CGPoint(x: -115, y: 80)
        timerLabel.zPosition = 100
        addChild(timerLabel)
        

        bubbleCount.position = CGPoint(x: 0, y: 80)
        bubbleCount.zPosition = 90
        bubbleCount.name = "timerCount"
        addChild(bubbleCount)
        
    
        bubbleLabel.text = "\(bubblesCatch)"
        bubbleLabel.fontSize = 24
       
        bubbleLabel.fontColor = SKColor.white
        bubbleLabel.horizontalAlignmentMode = .left
        bubbleLabel.position = CGPoint(x: 15, y: 80)
        bubbleLabel.zPosition = 100
        addChild(bubbleLabel)
      
        
        
        totalBubbleCount.position = CGPoint(x: 125, y: 80)
        totalBubbleCount.zPosition = 99
        totalBubbleCount.name = "timerCount"
        addChild(totalBubbleCount)
        
    
        totalBubbleLabel.text = "\(totalBubblesCatch)"
        totalBubbleLabel.fontSize = 24
       
        totalBubbleLabel.fontColor = SKColor.white
        totalBubbleLabel.horizontalAlignmentMode = .left
        totalBubbleLabel.position = CGPoint(x: 140, y: 80)
        totalBubbleLabel.zPosition = 100
        addChild(totalBubbleLabel)
    }
    
    func addTimeBonus() {
        
        secondsLeft = secondsLeft + 5
        defaults.set( secondsLeft, forKey: "increaseTime")
        self.startTime = self.defaults.integer(forKey: "increaseTime")
        self.timerLabel.text = "\(self.startTime)"
        
    }
    
    func unlockAsset() {
        
        theAssetState.add(assetStateChange: false)
        self.horseAsset = false
    }
    
    func setupStartButton() {
        
        ruleLabel.text = "Touch the Seahorse balls in descending order."
        ruleLabel.fontSize = 18
        ruleLabel.fontColor = SKColor.white
        ruleLabel.horizontalAlignmentMode = .left
        ruleLabel.position = CGPoint(x: -180 , y: frame.midY - 200)
        ruleLabel.zPosition = 100
        addChild(ruleLabel)
 
        play.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        play.zPosition = 2
        
        self.addChild(play)
        play.name = "playBtn"

    // Add animation
    let scaleUp = SKAction.scale(to: 0.55, duration: 0.65)
    let scaleDown = SKAction.scale(to: 0.50, duration: 0.65)
    let playBounce = SKAction.sequence([scaleDown, scaleUp])
    let bounceRepeat = SKAction.repeatForever(playBounce)
        play.run(bounceRepeat)

    }
    
    func showStartButton() {
        play.run(SKAction.fadeIn(withDuration: 0.25))
        ruleLabel.run(SKAction.fadeIn(withDuration: 0.25))
    }
    func hideStartButton() {
        play.run(SKAction.fadeOut(withDuration: 0.25))
        ruleLabel.run(SKAction.fadeOut(withDuration: 0.25))
    }
    
    func gameOver(){
        
        if defaults.object(forKey: "increaseTime") != nil {
            
            startTime = defaults.integer(forKey: "increaseTime")
            self.timerLabel.text = "\(self.startTime)"
            print(startTime)
            
        }else  {
            
            startTime = secondsLeft
            print(startTime)
        }
        
        showStartButton()
        nrOfBubbles = 5
        number = 0
        bubblesCatch = 0
        bubbleLabel.text = "\(bubblesCatch)"
        timerLabel.text =  "\(startTime)"
        playerNameArr.removeAll()
        for enemy in arrplayer {
            enemy.removeFromParent()
            
        }
        
    }
    
    
    func startTheTimer() {
        
        theTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countdownTimer), userInfo: nil, repeats: true)
    }
    
    @objc func countdownTimer(){

        startTime -= 1
        timerLabel.text =  "\(startTime)"
        
        if startTime == 0 {
            theTimer.invalidate()
            gameOver()
        }
        //
    }
    
    func createPlayer(){
  
        for int in 1...nrOfBubbles where int < nrOfBubbles {
   
            populateStage()
            number += randomCount
             
        }
        
    }
    
    func populateStage() {

        let randomX = CGFloat.random(in: -160...160)
        let randomY = CGFloat.random(in: -370...5)
        let bubbleNumberText:SKLabelNode = SKLabelNode(fontNamed: "Arial")

        bubbleNumberText.fontSize = 40
        bubbleNumberText.verticalAlignmentMode = .center
        bubbleNumberText.fontColor = SKColor.black
        bubbleNumberText.text = String(number)
        bubbleNumberText.zPosition = 3

       let player: SKSpriteNode = SKSpriteNode(imageNamed: "horse")
        player.position = CGPoint(x: randomX, y: randomY)
        player.zPosition = 4
        player.name = String(number)
        player.addChild(bubbleNumberText)
        self.addChild(player)

        playerNameArr.append(player.name!)
        arrplayer.append(player)
//
    }
        
 
    
    override func update(_ currentTime: TimeInterval) {

        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
        
        let touchN = atPoint (pos)
        
        if touchN.name == "playBtn"{
            
            createPlayer()
            
            startTheTimer()
            hideStartButton()
            //
        }
        
        let touchedN = nodes(at: pos)
        for touchedNode in touchedN {
            
            //
            
            if touchedNode.name == playerNameArr.last {
                //
                touchedNode.removeFromParent()
                
                playerNameArr.removeLast()
                
                bubblesCatch = bubblesCatch + 1
                
                bubbleLabel.text = "\(bubblesCatch)"
                
                totalBubblesCatch = bubblesCatch
                
                totalBubbleLabel.text = "\(totalBubblesCatch)"
                
                if totalBubblesCatch >= 15 {
                    
                    unlockAsset()
  
                }

                if playerNameArr.isEmpty {
//                    print("is empty.")
                    createPlayer()
                    nrOfBubbles = nrOfBubbles+1
                    number = 0

                }
                
                return

                
            }else if touchedNode.name != playerNameArr.last && touchedNode.name != "background" && touchedNode.name != "playBtn" && touchedNode.name != nil{
                print("erro")
                print(touchedNode.name as Any)
      
                theTimer.invalidate()
  
                gameOver()
                //
            }
            
        }
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

//
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
}



