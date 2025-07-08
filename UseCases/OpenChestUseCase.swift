//
//  OpenChestUseCase.swift
//  LabyrinthGame
//
//  Created by Aknazar Sherniiazov on 4/7/25.
//

import Foundation

struct OpenChestUseCase {
    func execute(player: Player, grid: [[Room]]) -> Bool {
        let room = grid[player.y][player.x]
        guard room.hasChest,
              player.inventory.contains(.key) else {
            return false
        }
        return true
    }
}
