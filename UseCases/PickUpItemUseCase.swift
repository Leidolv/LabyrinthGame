//
//  PickUpItemUseCase.swift
//  LabyrinthGame
//
//  Created by Aknazar Sherniiazov on 4/7/25.
//

import Foundation

struct PickUpItemUseCase {
    private let aliases: [String: String] = [
        "torch": "torchlight"
    ]
    func execute(itemName: String, player: Player, grid: inout [[Room]]) -> Bool {
        let key = itemName.lowercased()
        let wanted = aliases[key] ?? key
        
        let room = grid[player.y][player.x]
        guard let idx = room.items.firstIndex(where: { $0.name.lowercased() == wanted }) else { return false }
        let item = room.items.remove(at: idx)
        player.inventory.append(item)
        grid[player.y][player.x] = room
        return true
    }
}
