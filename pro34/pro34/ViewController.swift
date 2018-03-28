//
//  ViewController.swift
//  pro34
//
//  Created by mahmoud6 on 3/15/18.
//  Copyright © 2018 mahmoud6. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {

    @IBOutlet var columsButtons: [UIButton]!
    var placedChips = [[UIView]]()
    var board : Board!
    var stratgest : GKMinmaxStrategist!
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0 ..< Board.width {
            
            placedChips.append([UIView]())
            
        }
        stratgest = GKMinmaxStrategist()
        stratgest.maxLookAheadDepth = 7
        stratgest.randomSource = nil
        
        restBoard()
    }

    func restBoard(){
        
        board = Board()
        stratgest.gameModel = board
        
        UpdateUI()
        
        for i in 0..<placedChips.count{
            for chip in placedChips[i]{
                chip.removeFromSuperview()
            }
            placedChips[i].removeAll(keepingCapacity: true)
        }
        
    }
    
    func addChip(column : Int , row : Int , color : UIColor){
        
        let button = columsButtons[column]
        let size = min(button.frame.width , button.frame.height/6)
        let rect = CGRect(x: 0, y: 0, width: size, height: size)
        
        if (placedChips[column].count < row + 1) {
            
            
            let newChip = UIView()
            newChip.backgroundColor = color
            newChip.isUserInteractionEnabled = false
            newChip.frame = rect
            newChip.center = positionForChip(column : column , row : row)
            newChip.layer.cornerRadius = size/2
            newChip.transform = CGAffineTransform(translationX: 0, y: -300)
            view.addSubview(newChip)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {newChip.transform = CGAffineTransform.identity})
            
            placedChips[column].append(newChip)
            
        }
       
        
        
    }
    
    func positionForChip(column : Int , row : Int)-> CGPoint{
        
        let button = columsButtons[column]
        let size = min(button.frame.width , button.frame.height/6)
        
        let offsetx = button.frame.midX
        var offesty = button.frame.maxY
        offesty -= size * CGFloat(row)
        
        return CGPoint(x : offsetx , y : offesty)
    }
    
    
    @IBAction func makeMove(_ sender: UIButton) {
        
        let column = sender.tag
        
        if let row = board.nextEmptyslot(in: column) {
            board.add(chip: board.currentPlayer.chip, column: column)
            addChip(column: column, row: row, color: board.currentPlayer.color)
            continueGame()
        }
        
    }
    
    func UpdateUI(){
        
        
    title = "\(board.currentPlayer.name)' turn"
        
    }
    
    func continueGame(){
        
        var gameOverTitle : String? = nil
        
        
        if board.isWin(for : board.currentPlayer) {
            
            gameOverTitle = "\(board.currentPlayer.name) Won"
            
        }else if board.isFull() {
            
            gameOverTitle = "drawn"
        }
        
        if gameOverTitle != nil {
            
            let ac = UIAlertController(title: gameOverTitle, message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "playAgain", style: .default) { [unowned self] (action) in
                self.restBoard() })
            present(ac, animated: true)
            
            return
        }
        
        board.currentPlayer = board.currentPlayer.opponent
        UpdateUI()
        
    }
    func columnForAIMove()-> Int? {
        
        if let aiMove = stratgest.bestMove(for: board.currentPlayer) as? Move {
            return aiMove.column
        }
        
        return nil
    }
    func makeAIMove(column : Int){
        if let row = board.nextEmptyslot(in: column) {
            board.add(chip: board.currentPlayer.chip, column: column)
            addChip(column: column, row: row, color: board.currentPlayer.color)
       
            
            continueGame()
        }
    }
    func startAIMove(){
        
        DispatchQueue.main.async {[unowned self] in
            
            let time = CFAbsloteCurrentTime()
            
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

