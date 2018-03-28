//
//  Move.swift
//  pro34
//
//  Created by mahmoud6 on 3/19/18.
//  Copyright © 2018 mahmoud6. All rights reserved.
//

import UIKit
import GameplayKit

class Move: NSObject , GKGameModelUpdate {
    
    var value: Int = 0
    
    var column : Int
    
    init(column : Int) {
        
        self.column = column
    }

}
