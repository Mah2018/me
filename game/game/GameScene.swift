//
//  GameScene.swift
//  game
//
//  Created by mahmoud6 on 2/13/18.
//  Copyright © 2018 mahmoud6. All rights reserved.
//

import SpriteKit
import GameplayKit

enum collisionTypes : UInt32 {
    
    case player = 1
    case banana = 2
    case building = 4
    
}

class GameScene: SKScene  , SKPhysicsContactDelegate{
    var player1 : SKSpriteNode!
    var player2 : SKSpriteNode!
    var banana : SKSpriteNode!
    var currentPlayer = 1
    
    weak var ViewController : GameViewController!
    var buildings = [BuildingNode]()
        override func didMove(to view: SKView) {
            
            backgroundColor = UIColor(hue :0.699 , saturation :0.67 , brightness :0.99 , alpha :1)
        physicsWorld.contactDelegate = self
      createBuilding()
            createPlayer()
        }
    
    func createBuilding(){
    
        
        
        var currentX : CGFloat = -1000
        
        while currentX < 500 {
            let size = CGSize(width : RandomInt(min: 2, max: 4) * 40 , height : RandomInt(min: 300, max: 600) - 250 )

            
            currentX +=  size.width + 2
            let building = BuildingNode(color : UIColor.red , size : size )
            building.position = CGPoint(x: currentX - (size.width/2) , y :  size.height / 2)
            building.setup()
            addChild(building)
            buildings.append(building)
            
            
        }
    
    
    }
   func createPlayer(){
    
    player1 = SKSpriteNode(imageNamed : "Player")
    player1.name = "player1"
    player1.physicsBody = SKPhysicsBody(circleOfRadius : player1.size.width/2)
    player1.position = CGPoint(x : buildings[2].position.x , y :2 * buildings[2].position.y + player1.size.height / 2  )
    player1.physicsBody?.isDynamic = false
    player1.physicsBody?.categoryBitMask = collisionTypes.player.rawValue
    player1.physicsBody?.contactTestBitMask = collisionTypes.banana.rawValue
    player1.physicsBody?.collisionBitMask = collisionTypes.banana.rawValue
    
    addChild(player1)
    
    player2 = SKSpriteNode(imageNamed : "Player")
    player2.name = "player2"
    player2.physicsBody = SKPhysicsBody(circleOfRadius : player2.size.width/2)
    player2.position = CGPoint(x : buildings[buildings.count - 2].position.x , y : 2 * buildings[buildings.count - 2].position.y + player1.size.height / 2  )
    player2.physicsBody?.isDynamic = false
    player2.physicsBody?.categoryBitMask = collisionTypes.player.rawValue
    player2.physicsBody?.contactTestBitMask = collisionTypes.banana.rawValue
    player2.physicsBody?.collisionBitMask = collisionTypes.banana.rawValue
    
    addChild(player2)
    

    
    
    }
    
   
    
    func launch(angle : Int , velocity : Int){
        
     let speed = velocity / 10
        
        
      let rad = deg2rad(angle: angle)
        
        if banana != nil {
            
            banana.removeFromParent()
            banana = nil
        }
        
        banana = SKSpriteNode(imageNamed : "banana")
        banana.physicsBody = SKPhysicsBody (circleOfRadius : banana.size.width/2)
        banana.physicsBody?.usesPreciseCollisionDetection = true
        banana.physicsBody?.categoryBitMask = collisionTypes.banana.rawValue
        banana.physicsBody?.collisionBitMask = collisionTypes.player.rawValue | collisionTypes.building.rawValue
        banana.physicsBody?.contactTestBitMask = collisionTypes.player.rawValue | collisionTypes.building.rawValue
        addChild(banana)
        
        if currentPlayer == 1 {
        
            banana.position = CGPoint(x : player1.position.x - 30 ,y : player1.position.y + 40  )
            banana.physicsBody?.angularVelocity = -20
            
            let raise = SKAction.setTexture(SKTexture(imageNamed : "player1Throw"))
            let pause = SKAction.wait(forDuration: 0.5)
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed : "player"))
        
            let sequence = SKAction.sequence([raise , pause, lowerArm])
            player1.run(sequence)
         
            let impulse = CGVector(dx : speed *  Int(cos(rad)) , dy : speed * Int(sin(rad)))
            banana.physicsBody?.applyImpulse(impulse)
            
        }else {
            
            banana.position = CGPoint(x : player2.position.x - 30 ,y : player2.position.y + 40  )
            banana.physicsBody?.angularVelocity = -20
            
            let raise = SKAction.setTexture(SKTexture(imageNamed : "player2Throw"))
            let pause = SKAction.wait(forDuration: 0.5)
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed : "player"))
            
            let sequence = SKAction.sequence([raise , pause, lowerArm])
            player1.run(sequence)
            
            let impulse = CGVector(dx : speed *  Int(cos(rad)) , dy : speed * Int(sin(rad)))
            banana.physicsBody?.applyImpulse(impulse)
 
            
            
            
            
        }
        
        
        
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let firstBody: SKPhysicsBody
        let secondBody : SKPhysicsBody
        
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if let firstNode = firstBody.node {
            if let secondNode = secondBody.node {
                
                
                if (firstNode.name == "banana" && secondNode.name == "building"){
                    buildingHit(building :secondNode as! BuildingNode , atPoint : contact.contactPoint)
                    
                }
                if (firstNode.name == "banana" && secondNode.name == "player1"){
                    
                    
                    destroy(player : player1)
                }
                if (firstNode.name == "banana" && secondNode.name == "player2"){
                    destroy(player : player2)
                }
            }
        }
        
        
        
    }
    
    
    
    func destroy(player : SKSpriteNode){
        
        let explosion = SKEmitterNode(fileNamed :"hitPlayer")
        explosion?.position = player.position
        addChild(explosion!)
        
        player.removeFromParent()
        banana.removeFromParent()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){ [unowned self] in
            
            let newGame = GameScene(size : self.size)
            let transition = SKTransition.doorway(withDuration: 2)
            self.view?.presentScene(newGame, transition : transition)
            
            newGame.ViewController = self.ViewController
            self.ViewController.currentGame = newGame
            
            self.ChangePlayer()
            newGame.currentPlayer = self.currentPlayer
            
            
        
        }
        
    }
    
    func ChangePlayer(){
        if currentPlayer == 1 {
            currentPlayer = 2
        }else {
            currentPlayer = 1
        }
        ViewController.activePlayer(number: currentPlayer)
    }
    func buildingHit(building : BuildingNode , atPoint location : CGPoint){
        
        
        
        
        
    }
    
    func deg2rad(angle : Int) -> Double {
    
    
    let rad = Double(angle) * Double.pi / 180
    
        return rad
    
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        }
        

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
           }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
           }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
}

    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
