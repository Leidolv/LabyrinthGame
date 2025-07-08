//
//  MovePlayerUseCase.swift
//  LabyrinthGame
//
//  Created by Aknazar Sherniiazov on 4/7/25.
//

import Foundation

struct MovePlayerUseCase {
    func execute(direction: Direction, player: Player, grid: [[Room]]) -> Bool {
        guard let room = currentRoom(player: player, grid: grid),
              room.doors.contains(direction),
              player.stepsRemaining > 0 else { return false }
        
        switch direction {
        case .north: player.y -= 1
        case .south: player.y += 1
        case .west: player.x -= 1
        case .east: player.x += 1
        }
        player.stepsRemaining -= 1
        return true
    }
    
    private func currentRoom(player: Player, grid: [[Room]]) -> Room? {
        guard player.y >= 0, player.y < grid.count,
              player.x >= 0, player.x < grid[player.y].count else { return nil }
        return grid[player.y][player.x]
    }
}
