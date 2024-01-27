//
//  TargetSlot.swift
//  ShootingGallery
//
//  Created by Михаил Тихомиров on 19.01.2024.
//
import SpriteKit
import UIKit

class TargetSlot: SKNode {
    
    enum targetSizes {
    case small, medium, big
    }

    var target:SKSpriteNode!
    var isHit = false
    var targets = ["target0", "target1", "target2", "target3"]
    
    func configure(at position:CGPoint, size:targetSizes, name:String) {
        
        targets.shuffle()
        self.position = position
        
        
        let stick = SKSpriteNode(imageNamed: "stick1")
        stick.position = CGPoint(x: 0, y: 15)
        addChild(stick)
        
        target = SKSpriteNode(imageNamed: targets[0])
        target.position = CGPoint(x: 0, y: name.hasPrefix("big") ? 70:50)
        target.name = name
        target.zPosition = 1
        addChild(target)
        
        target.physicsBody = SKPhysicsBody(texture: target.texture!, size: target.size)
        target.physicsBody?.categoryBitMask = 1
        target.physicsBody?.contactTestBitMask = 1  // our target like a ball can strike other targets
        
        
        
        
        
        switch size {
                case .small:
                    stick.xScale = 0.50
                    stick.yScale = 0.50
                    target.xScale = 0.50
                    target.yScale = 0.50
                case .medium:
                    stick.xScale = 0.65
                    stick.yScale = 0.65
                    target.xScale = 0.65
                    target.yScale = 0.65
                case .big:
                    stick.xScale = 0.80
                    stick.yScale = 0.80
                    target.xScale = 0.80
                    target.yScale = 0.80
                }
    }
}
