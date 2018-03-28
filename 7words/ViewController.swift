//
//  ViewController.swift
//  7words
//
//  Created by mahmoud6 on 12/28/17.
//  Copyright © 2017 mahmoud6. All rights reserved.
//
import GameKit
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var currentAnswer: UITextField!
    @IBOutlet weak var CluesLabel: UILabel!
    @IBOutlet weak var Answerlabel: UILabel!
    @IBOutlet weak var Scorelabel: UILabel!
    var level = 1
    var letterbuttons = [UIButton]()
    
    var activeButtons = [UIButton]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        loadLevel()
        
        
        
        
    }
    
    
    func loadLevel(){
    
    var cluString = ""
        var answerstring = ""
        var lettersbites = [String]()
        
        if let filepath = Bundle.main.path(forResource: "level\(level)", ofType: "txt"){
            
            if let datastring = try? String(contentsOfFile: filepath ){
            
            
         var   lines = datastring.components(separatedBy: "\n")
                
                lines = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: lines) as! [String]
             
                for (index,line) in lines.enumerated() {
                
                    let parts = line.components(separatedBy: ": ")
                    let Answer = parts[0]
                    let clue = parts[1]
                    
                    
                    
                    
                    
                    cluString += "\(index + 1)" + clue + "\n"
                    answerstring += (Answer.replacingOccurrences(of: "|", with: "")) + "\n"
                    
                    var bites = Answer.components(separatedBy: "|")
                    
                    lettersbites += bites
                
                
    
                
                
                }
                
                if lettersbites.count == letterbuttons.count {
                    
                    for i in 0..<lettersbites.count {
                    
                        letterbuttons[i].setTitle(lettersbites[i], for: .normal)
                        
                    }
                    
                }
                
            
            }
    
    
    
    
    }
        
    
    
    
    
    }
    
    
        @IBAction func clearTapped(_ sender: Any) {
            
            currentAnswer.text = ""
            
            for btn in activeButtons{
            
            btn.isHidden = false
            
            }
            
            activeButtons.removeAll()
    }

  
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        currentAnswer.text = currentAnswer.text! + sender.titleLabel!.text!
        
        activeButtons.append(sender)
        
        sender.isHidden = true
        
        
        
    }
    
    @IBAction func submitTapped(_ sender: AnyObject) {
        
        
        
        
        
        
        
    }
    
    
    
   
}

