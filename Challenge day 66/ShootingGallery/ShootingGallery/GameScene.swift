//
//  GameScene.swift
//  ShootingGallery
//
//  Created by Михаил Тихомиров on 17.01.2024.
//

import SpriteKit
import UIKit
import GameplayKit



class GameScene: SKScene, SKPhysicsContactDelegate {

    

    var targets = [TargetSlot]()
    
    let Lines = ["small1","small2","small3","medium1","medium2","medium3","big1","big2"]
    
    var shots = ["shots0", "shots1", "shots2", "shots3"]
    
    var test:SKSpriteNode!
    var scoreLabel:SKLabelNode!
    var shot:SKSpriteNode!
    var cursor:SKSpriteNode!
    var bubble:SKSpriteNode!
    var gameOverLabel:SKSpriteNode!
    var cursorMovement:Timer?
    var positionChange:Timer?
    var removeItemAfterTime:Timer?
    var validTouch:Bool = false
    var countOfMiss:Int = 3
    
    var reloadTimer:Timer?
    
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    
    var TimerOfCursor:Timer? {
        Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(cursorAnimation), userInfo: nil, repeats: true)
    }
    
    var TimerOfPosition:Timer? {
        Timer.scheduledTimer(timeInterval: 1.7, target: self, selector: #selector(changePosition), userInfo: nil, repeats: true)
    }
    
    var TimerOfRemove: Timer? {
        Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(removeItem), userInfo: nil, repeats: false)
    }
    
    
    func TimerOfReload() {
        reloadTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(reloadind), userInfo: nil, repeats: false)

    }
    
   
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "wood-background")
        background.position = CGPoint(x: 400, y: 300)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        

        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        newGame(action: nil)

        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        }
    
    func newGame(action:UIAlertAction!) {
        validTouch = false
        score = 0
        
        cursor = SKSpriteNode(imageNamed: "cursor")
        cursor.position = CGPoint(x: 400, y: 100)
        cursor.zPosition = 2
        addChild(cursor)
        
        shot = SKSpriteNode(imageNamed: shots[0])
        shot.position = CGPoint(x: 750, y: 30)
        addChild(shot)
        
    
        for number in 0..<Lines.count {
            
            if Lines[number].hasPrefix("small") {
                createTarget(at: CGPoint(x: 100 + number * 300, y: 500), size: .small, name: Lines[number])
            } else if Lines[number].hasPrefix("medium") {
                createTarget(at: CGPoint(x: 100 + ((number - 3) * 300), y: 300), size: .medium, name: Lines[number])
            } else if Lines[number].hasPrefix("big") {
                createTarget(at: CGPoint(x: 100 + ((number - 6) * 300), y: 100), size: .big, name: Lines[number])
            }
        }
        
        cursorMovement = TimerOfCursor
        positionChange = TimerOfPosition
        
    }
    


    @objc func changePosition() {
        for item in targets {
       
            switch item.target.name! {
            case "small1":
                item.position = CGPoint(x: Double(Int.random(in: 50...250)), y: item.position.y)
            case "small2":
                item.position = CGPoint(x: Double(Int.random(in: 310...510)), y: item.position.y)
            case "small3":
                item.position = CGPoint(x: Double(Int.random(in: 570...750)), y: item.position.y)
            case "medium1":
                item.position = CGPoint(x: Double(Int.random(in: 50...250)), y: item.position.y)
            case "medium2":
                item.position = CGPoint(x: Double(Int.random(in: 325...510)), y: item.position.y)
            case "medium3":
                item.position = CGPoint(x: Double(Int.random(in: 585...750)), y: item.position.y)
            case "big1":
                item.position = CGPoint(x: Double(Int.random(in: 50...400)), y: item.position.y)
            case "big2":
                item.position = CGPoint(x: Double(Int.random(in: 490...750)), y: item.position.y)
            default:
                break
            }
            
        }
        
        
        }
    
    
    func createTarget(at position: CGPoint, size:TargetSlot.targetSizes, name:String) {
        let target = TargetSlot()
        target.configure(at: position, size: size, name: name)
        addChild(target)
        targets.append(target)
    }
    

    
    
    @objc func cursorAnimation() {
        cursor.position = CGPoint(x: 400 + Int.random(in: 0...10), y: 100 + Int.random(in: 0...10))
    }
    
    
    @objc func reloadind() {
        
        // when it is being played firstly you`ve got a message and a delay for 0.5 sec, other shots happen perfectly
            run(SKAction.playSoundFileNamed("reload.wav", waitForCompletion: true))
    }
    
    
    func resetCursor() {
        validTouch = false
        cursorMovement = TimerOfCursor
        TimerOfReload()
    }

    
    
    func checkValidTouch(locationOfTouch:CGPoint){
        if (locationOfTouch.x >= 380 && locationOfTouch.x <= 430) && (locationOfTouch.y >= 80 && locationOfTouch.y <= 130) {
            validTouch = true
        }
    }
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if countOfMiss == 0 { return }
        
        let locationOfTouch = touch.location(in: self)
        
        if !validTouch {
            checkValidTouch(locationOfTouch: locationOfTouch)
        }else {
            cursorMovement?.invalidate()
            cursor.position = locationOfTouch
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if validTouch {
            
            
            bubble = SKSpriteNode(imageNamed: "bubbleGray")
            bubble.position = CGPoint(x: 400, y: -30)
            bubble.zPosition = 1
            bubble.physicsBody = SKPhysicsBody(texture: bubble.texture!, size: bubble.size)
            bubble.physicsBody?.contactTestBitMask = 1
            bubble.xScale = 0.4
            bubble.yScale = 0.4
            bubble.name = "bubble"
            addChild(bubble)
            
            // when it is being played firstly you`ve got a message and a delay for 0.5 sec, other shots happen perfectly
            run(SKAction.playSoundFileNamed("shot", waitForCompletion: false))
        
            bubble.physicsBody?.angularVelocity = 7
            bubble.physicsBody?.linearDamping = 0
            bubble.physicsBody?.angularDamping = 0
            
            // our vector for shot
            bubble.physicsBody?.velocity = CGVector(dx: Double(cursor.position.x) - 400, dy: Double(cursor.position.y) + 40)
            
            resetCursor()
            
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        
        positionChange?.invalidate()
        
        let spark = SKEmitterNode(fileNamed: "MyParticle")!
        spark.position = bubble.position
        addChild(spark)
        
        for item in targets {
            if nodeA.name == item.target.name {
                item.isHit = true
                item.target.physicsBody?.angularVelocity = 2
                item.target.physicsBody?.angularDamping = 3
            } else if nodeB.name == item.target.name {
                item.isHit = true
                item.target.physicsBody?.angularVelocity = 2
                item.target.physicsBody?.angularDamping = 3
            }
        }
        bubble.removeFromParent()
        
        score += 10
        
        positionChange = TimerOfPosition
        removeItemAfterTime = TimerOfRemove
        
       

    }
    
    
    @objc func removeItem() {
        for item in targets {
            if item.isHit {
                item.removeFromParent()
                targets.remove(at: targets.firstIndex(of: item)!)
            }
        }
        // when we win this game
        if targets.isEmpty { gameOver() }
        
    }
    
        
    func gameOver() {
        guard let viewController = self.view?.window?.rootViewController else { return }
        
        countOfMiss = 3
        positionChange?.invalidate()
        cursorMovement?.invalidate()
        validTouch = false
        
        
        
        if !targets.isEmpty {
            gameOverLabel = SKSpriteNode(imageNamed: "game-over")
            gameOverLabel.position = CGPoint(x: 400, y: 300)
            gameOverLabel.zPosition = 2
            addChild(gameOverLabel)
    
            let ac = UIAlertController(title: "Game is over!", message: "Start again", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
                
                self?.cleanSurface()
                self?.newGame(action: nil)
                
            }))
            viewController.present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "You finished the game!", message: "Start again", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
                
                self?.cleanSurface()
                self?.newGame(action: nil)
                
            }))
            viewController.present(ac, animated: true)
        }
        
    }
    
    func cleanSurface() {
        gameOverLabel?.removeFromParent()
        shot.removeFromParent()
        cursor.removeFromParent()
        
        for target in targets {
            target.removeFromParent()
        }
        targets.removeAll(keepingCapacity: true)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if countOfMiss == 0 {
            // when we loose this game
            gameOver()
        }
        
        
        for node in children {
            if node.position.x < 0 || node.position.x > 800 || node.position.y > 600 {
                node.removeFromParent()
                score -= 10
              
                shot.removeFromParent()
                countOfMiss -= 1
                shot = SKSpriteNode(imageNamed: shots[3 - countOfMiss])
                shot.position = CGPoint(x: 750, y: 30)
                addChild(shot)
            }
        }
    }
}
