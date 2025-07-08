//
//  Player.swift
//  LabyrinthGame
//
//  Created by Aknazar Sherniiazov on 4/7/25.
//

import Foundation

class Player {
    
    // MARK: - Properties
    var x: Int
    var y: Int
    var inventory: [Item] = []
    var stepsRemaining: Int
    
    init(startX: Int, startY: Int, steps: Int) {
        self.x = startX
        self.y = startY
        self.stepsRemaining = steps
    }
    
    func has(item: Item) -> Bool {
        return inventory.contains(item)
    }
}



