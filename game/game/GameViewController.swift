//
//  GameViewController.swift
//  game
//
//  Created by mahmoud6 on 2/13/18.
//  Copyright © 2018 mahmoud6. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
   
    
    @IBOutlet weak var launchButton: UIButton!
    @IBOutlet weak var velocitySlider: UISlider!
    @IBOutlet weak var velocityLabel: UILabel!
    @IBOutlet weak var playerNumber: UILabel!
    @IBOutlet weak var angleLabel: UILabel!
    @IBOutlet weak var angleSlider: UISlider!
    
    
    var currentGame : GameScene!
    override func viewDidLoad() {
        super.viewDidLoad()
        angleChanged(angleSlider)
        velocityChanged(velocitySlider)
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                currentGame = scene as! GameScene
                currentGame.ViewController = self
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func activePlayer(number : Int){
        
        if number == 1 {
            playerNumber.text = "<<PlayerONE"
        }else
        {
        playerNumber.text = "PlayerTWO>>"
        }
        angleSlider.isHidden = false
        velocitySlider.isHidden = false
        
    }
    
    @IBAction func angleChanged(_ sender: Any) {
        
        angleLabel.text = "angle : \(Int(angleSlider.value))"
    }
    
    @IBAction func velocityChanged(_ sender: Any) {
        
        velocityLabel.text = "velocity : \(Int(velocitySlider.value))"
    }

    
    @IBAction func launchTapped(_ sender: Any) {
        
        angleSlider.isHidden = true
        velocitySlider.isHidden = true
        currentGame.launch(angle : Int(angleSlider.value) , velocity : Int(velocitySlider.value))
        
        
    }
    
    
    
    

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
