//
//  Board.swift
//  pro34
//
//  Created by mahmoud6 on 3/15/18.
//  Copyright © 2018 mahmoud6. All rights reserved.
//

import UIKit
import GameplayKit

enum chipColor : Int {
    case none = 0
    case red
    case black
    
}
class Board: NSObject , GKGameModel{
    
    var players: [GKGameModelPlayer]? {
    return Player.allPlayers
    }
    
    var activePlayer: GKGameModelPlayer? {
        return currentPlayer
    }
    
    
   static var width = 7
   static var height = 6
  var currentPlayer : Player
    var slots = [chipColor]()
    
    override init() {
        currentPlayer = Player.allPlayers[0]
        
        for _ in 0 ..< Board.width * Board.height {
            
            slots.append(.none)
        }
        super.init()
    }
  
    
    func set(in column : Int , row : Int ,chip : chipColor){
        
        slots[row + column * Board.height] = chip
    }
    
    func chip(inColumn column : Int , row : Int ) -> chipColor {
        return slots[row + column * Board.height]
    }
    
    func nextEmptyslot(in column : Int) -> Int?{
    
        for row in 0 ..< Board.height {
            
            if chip(inColumn: column, row: row) == .none {
                return row
            }
            
        }
    
        return nil
    }

    func canMove(in column : Int) -> Bool {
    return nextEmptyslot(in: column) != nil
        
    }
   
    
    func add(chip : chipColor , column : Int) {
        
        if let row = nextEmptyslot(in: column){
            set(in: column, row: row, chip: chip)
        }
    }
    func isFull()-> Bool{
        
        for column in 0 ..< Board.width {
            if canMove(in: column){
                return false
            }
        }
        return true
    }
    
    func isWin(for player: GKGameModelPlayer) -> Bool {
        let chip = (player as! Player).chip
        
        for row in 0 ..< Board.height {
            for col in 0 ..< Board.width {
                if squaresMatch(initialChip: chip, row: row, col: col, moveX: 1, moveY: 0) {
                    return true
                } else if squaresMatch(initialChip: chip, row: row, col: col, moveX: 0, moveY: 1) {
                    return true
                } else if squaresMatch(initialChip: chip, row: row, col: col, moveX: 1, moveY: 1) {
                    return true
                } else if squaresMatch(initialChip: chip, row: row, col: col, moveX: 1, moveY: -1) {
                    return true
                }
            }
        }
        
        return false
    }
    func squaresMatch(initialChip: chipColor, row: Int, col: Int, moveX: Int, moveY: Int) -> Bool {
        // bail out early if we can't win from here
        if row + (moveY * 3) < 0 { return false }
        if row + (moveY * 3) >= Board.height { return false }
        if col + (moveX * 3) < 0 { return false }
        if col + (moveX * 3) >= Board.width { return false }
        
        // still here? Check every square
        if chip(inColumn: col, row: row) != initialChip { return false }
        if chip(inColumn: col + moveX, row: row + moveY) != initialChip { return false }
        if chip(inColumn: col + (moveX * 2), row: row + (moveY * 2)) != initialChip { return false }
        if chip(inColumn: col + (moveX * 3), row: row + (moveY * 3)) != initialChip { return false }
        
        return true
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        
        let copy = Board()
        copy.setGameModel(self)
        return copy
        
    }
    func setGameModel(_ gameModel: GKGameModel) {
        
        if let board = gameModel as? Board {
            
            slots = board.slots
            currentPlayer = board.currentPlayer
        }
    }
    
    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
      
        
        if let playerObject = player as? Player {
            
            if isWin(for: playerObject){
            return nil
            }
        }
        var moves = [Move]()
        
        for column in 0..<Board.height {
            
            if canMove(in: column){
                moves.append(Move(column: column))
            }
            return moves
        }
        
        return nil
    }
    
    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        
        if let move = gameModelUpdate as? Move {
            
            add(chip: currentPlayer.chip, column: move.column)
            currentPlayer = currentPlayer.opponent
        }
    }
    
    func score(for player: GKGameModelPlayer) -> Int {
        
        if let playerObject = player as? Player {
            if isWin(for: playerObject){
                return 1000
            }else if isWin(for: playerObject.opponent){
                return -1000
         
            }
        }
        return 0
    }
    
    
}
