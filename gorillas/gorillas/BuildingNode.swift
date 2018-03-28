//
//  BuildingNode.swift
//  gorillas
//
//  Created by mahmoud6 on 3/28/18.
//  Copyright © 2018 mahmoud6. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class BuildingNode: SKSpriteNode {

    var currentImage : UIImage!
    
    func setup(){
        
        name = "Building"
        texture = SKTexture(image: currentImage)
        currentImage = drawBuilding(size : size)
        
        configurePhysics()
        
        
    }

    func configurePhysics(){
        
        physicsBody = SKPhysicsBody(texture: texture!, size: size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CollisionTypes.building.rawValue
        physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue

    }
    
    func drawBuilding(size : CGSize)-> UIImage {
        
    let renederer = UIGraphicsImageRenderer(size: size)
        
        let image = renederer.image { (ctx) in
            
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            var color : UIColor!
            switch GKRandomSource.sharedRandom().nextInt(upperBound: 3){
            case 0:
                
                color = UIColor(hue: 0.502, saturation: 0.98, brightness: 0.67, alpha: 1)
            case 1:
                color = UIColor(hue: 0.999, saturation: 0.99, brightness: 0.67, alpha: 1)
            default:
                color = UIColor(hue: 0, saturation: 0, brightness: 0.67, alpha: 1)
            }
            
        
            ctx.cgContext.addRect(rect)
            ctx.cgContext.setFillColor(color.cgColor)
            ctx.cgContext.drawPath(using: .fill)
            // 3
            let lightOnColor = UIColor(hue: 0.190, saturation: 0.67, brightness: 0.99, alpha: 1)
            let lightOffColor = UIColor(hue: 0, saturation: 0, brightness: 0.34, alpha: 1)
            
            for row in stride(from: 10, to: Int(size.height - 10), by: 40) {
                for col in stride(from: 10, to: Int(size.width - 10), by: 40) {
                    if RandomInt(min: 0, max: 1) == 0 {
                        ctx.cgContext.setFillColor(lightOnColor.cgColor)
                    } else {
                        ctx.cgContext.setFillColor(lightOffColor.cgColor)
                    }
                    
                    ctx.cgContext.fill(CGRect(x: col, y: row, width: 15, height: 20))
                }
            }

            
        }
        
        
        return image
        
    }
    
    

}
