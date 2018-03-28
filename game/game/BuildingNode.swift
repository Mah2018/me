//
//  BuildingNode.swift
//  game
//
//  Created by mahmoud6 on 2/13/18.
//  Copyright © 2018 mahmoud6. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class BuildingNode: SKSpriteNode{

    var currentImage : UIImage!
    
    func setup(){
        
     name = "building"
        
        currentImage = drawBuilding(size : size )
        texture = SKTexture(image : currentImage)
        
        
        configureBuilding()
        
        
    }
    
    
    
    func configureBuilding(){
        
        physicsBody = SKPhysicsBody(texture : texture! , size : size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = collisionTypes.building.rawValue
        physicsBody?.contactTestBitMask = collisionTypes.banana.rawValue
    
        
    }
    
    func drawBuilding(size : CGSize)->UIImage {
        
        let renderer = UIGraphicsImageRenderer(size : size)
        
        let img = renderer.image { (ctx) in
            
            let rect = CGRect(x : 0.5 , y : 0.5 , width : size.width , height : size.height)
            
            var color : UIColor!
            
            
            switch GKRandomSource.sharedRandom().nextInt(upperBound: 3) {
            case 0:
                color = UIColor(hue: 0.502, saturation: 0.98, brightness: 0.67, alpha: 1)
            case 1:
                color = UIColor(hue: 0.999, saturation: 0.99, brightness: 0.67, alpha: 1)
            default:
                color = UIColor(hue: 0, saturation: 0, brightness: 0.67, alpha: 1)
            }
            
            ctx.cgContext.setFillColor(color.cgColor)
            ctx.cgContext.addRect(rect)
            ctx.cgContext.drawPath(using: .fill)
            
            let lightOnColor = UIColor(hue: 0.190, saturation: 0.67, brightness: 0.99, alpha: 1)
            let lightOffColor = UIColor(hue: 0, saturation: 0, brightness: 0.34, alpha: 1)
            
            for row in stride(from : 10 , to : size.height-10 , by : 40){
                for col in stride(from : 10 , to : size.width-10 , by : 40){
                    if RandomInt(min: 0, max: 1) == 0 {
                        ctx.cgContext.setFillColor(lightOnColor.cgColor)
                    } else {
                        ctx.cgContext.setFillColor(lightOffColor.cgColor)
                    }
                    
                    ctx.cgContext.fill(CGRect(x: col, y: row, width: 15, height: 20))
                }
            }
            
            
            
        }
        
        return img
        
    }
    
    
    
    
}
