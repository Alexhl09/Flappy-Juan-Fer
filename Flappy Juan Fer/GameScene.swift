//
//  GameScene.swift
//  Flappy Juan Fer
//
//  Created by Alejandro on 01/01/17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

import SpriteKit
struct Fisica {
    static let jf : UInt32 = 0x1 << 1
    static let fondo : UInt32 = 0x1 << 2
    static let wallPair : UInt32 = 0x1 << 3
    static let score : UInt32 = 0x1 << 4

}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
  var fondo = SKSpriteNode()
    var jf = SKSpriteNode()

    var wallPair = SKNode()
    var moveAndRemove = SKAction()
    var gameStarted = Bool()
    var score = Int()
    let scoreL = SKLabelNode()
    var died = Bool()
    var restart = SKSpriteNode()
    
    func restartScene(){
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStarted = false
        score = 0
        createScene()
        
        
    }
    func createScene(){
       
        
        self.physicsWorld.contactDelegate = self
        
        for i in 0..<2 {
            let background = SKSpriteNode(imageNamed: "bg")
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: CGFloat(i) * self.frame.width - 400, y: self.frame.midY - 430)
            background.name = "background"
            background.setScale(3)
            self.addChild(background)
        }
       
        scoreL.setScale(2.5)
        scoreL.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 500 )
        scoreL.text = "\(score)"
        scoreL.fontName = "04b_19"
        scoreL.zPosition = 5
        
        self.addChild(scoreL)
        
        fondo = SKSpriteNode(imageNamed: "ground")
        fondo.setScale(2.3)
        
        fondo.position = CGPoint(x: self.frame.width / 100, y: -540  )
        fondo.physicsBody = SKPhysicsBody(rectangleOf: fondo.size)
        fondo.physicsBody?.categoryBitMask = Fisica.fondo
        fondo.physicsBody?.collisionBitMask = Fisica.jf
        fondo.physicsBody?.contactTestBitMask = Fisica.jf
        fondo.physicsBody?.affectedByGravity = false
        fondo.physicsBody?.isDynamic = false
        fondo.zPosition = 3
        
        self.addChild(fondo)
        
        
        jf = SKSpriteNode(imageNamed: "Juano")
    
        jf.setScale(2.4)
        jf.position = CGPoint(x: self.frame.size.width  - jf.frame.width , y: self.frame.midY)
               jf.physicsBody = SKPhysicsBody(circleOfRadius: jf.frame.height / 90 - 22 )
        jf.physicsBody?.categoryBitMask = Fisica.jf
        jf.physicsBody?.collisionBitMask = Fisica.fondo | Fisica.wallPair
        jf.physicsBody?.contactTestBitMask = Fisica.fondo | Fisica.wallPair | Fisica.score
        jf.physicsBody?.affectedByGravity = false
        jf.physicsBody?.isDynamic = true
        
        jf.zPosition = 2
        self.addChild(jf)

        
    }
    
    
    override func didMove(to view: SKView) {
        
        createScene()
       
            }
    
    func createBTN(){
        
        restart = SKSpriteNode(imageNamed : "restart")
        restart.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        restart.zPosition = 6
        restart.setScale(2)
        self.addChild(restart)
        
        restart.run(SKAction.scale(to: 1.0, duration: 0.4))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == Fisica.score && secondBody.categoryBitMask == Fisica.jf  {
            score += 1
            scoreL.text = "\(score)"
            firstBody.node?.removeFromParent()
            
        } else
        if
         firstBody.categoryBitMask == Fisica.jf && secondBody.categoryBitMask == Fisica.score {
            score += 1
            scoreL.text = "\(score)"
            secondBody.node?.removeFromParent()
            
        }
        
        else
       if firstBody.categoryBitMask == Fisica.jf && secondBody.categoryBitMask == Fisica.wallPair || firstBody.categoryBitMask == Fisica.wallPair && secondBody.categoryBitMask == Fisica.jf{
            
            
            
         enumerateChildNodes(withName: "wallPair", using: ({
            ( node , error) in
            node.speed = 0
            self.removeAllActions()
        }))
            if died == false {
                died = true
            createBTN()
        }
        }
        else if firstBody.categoryBitMask == Fisica.jf && secondBody.categoryBitMask == Fisica.fondo || firstBody.categoryBitMask == Fisica.fondo && secondBody.categoryBitMask == Fisica.jf{
            
            
            
            enumerateChildNodes(withName: "wallPair", using: ({
                ( node , error) in
                node.speed = 0
                self.removeAllActions()
            }))
            if died == false {
                died = true
                createBTN()
            }
        }}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false {
            gameStarted = true
            
            jf.physicsBody?.affectedByGravity = true
            
            let spawn = SKAction.run({
                () in
                self.createWall()
            })
            let delay = SKAction.wait(forDuration: 2 )
            let spawnDelay = SKAction.sequence([spawn,delay])
            let spawnDelayForever = SKAction.repeatForever(spawnDelay)
            self.run(spawnDelayForever)
            
            let distance = CGFloat(self.frame.size.width + 4 * wallPair.frame.width)
            let movePipes = SKAction.moveBy(x: -distance - 450, y: 0, duration: TimeInterval( 0.008 * distance))
            let removePipes = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePipes,removePipes])
            jf.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            jf.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 7.4))
        }else {
            if died == true {
                
            }
            else{
            jf.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            jf.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 7.4))
        }
        }

        for touch in touches {
            let location = touch.location(in: self)
            if died == true {
                if restart.contains(location){
                    restartScene()
                }
            }
        }
            
        
    }

    func createWall (){
        
        let scoreNode = SKSpriteNode(imageNamed : "tarrp")
        
        scoreNode.size = CGSize(width: 50, height: 100)
        scoreNode.position = CGPoint(x: self.frame.width, y: self.frame.height / 13 )
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.physicsBody?.categoryBitMask = Fisica.score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = Fisica.jf
        scoreNode.color = SKColor.blue
    
        
        
        
         wallPair = SKNode()
        wallPair.name = "wallPair"
        
        
        let topWall = SKSpriteNode(imageNamed : "tube2")
        let btmWall = SKSpriteNode(imageNamed : "tube2")
        topWall.setScale(2.5)
        btmWall.setScale(2.5)
        
        
        topWall.position = CGPoint(x: self.frame.width, y : self.frame.height / 100 + 650 )
        btmWall.position = CGPoint(x: self.frame.width , y : self.frame.height / 100 - 425)
 
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = Fisica.wallPair
        topWall.physicsBody?.collisionBitMask = Fisica.jf
        topWall.physicsBody?.contactTestBitMask = Fisica.jf
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        
        

        btmWall.physicsBody = SKPhysicsBody(rectangleOf: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = Fisica.wallPair
        btmWall.physicsBody?.collisionBitMask = Fisica.jf
        btmWall.physicsBody?.contactTestBitMask = Fisica.jf
        btmWall.physicsBody?.isDynamic = false
        btmWall.physicsBody?.affectedByGravity = false

        topWall.zRotation = CGFloat(Double.pi)

        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        

        
        
        wallPair.zPosition = 1
        
        let ramdomPosition = CGFloat.ramdom(min: -300, max: 300)
        wallPair.position.y = wallPair.position.y + ramdomPosition
    
        wallPair.addChild(scoreNode)
        
        wallPair.run(moveAndRemove)
        self.addChild(wallPair)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if gameStarted == true {
            if died == false{
                enumerateChildNodes(withName: "background", using: ({
                    (node, error) in
                    let back = node as! SKSpriteNode
                    back.position = CGPoint(x: back.position.x - 1,y: back.position.y)
                    
                    if back.position.x <= -back.size.width {
                        back.position = CGPoint(x: back.position.x + 600 , y: back.position.y)
                    }
                }))}}}}

