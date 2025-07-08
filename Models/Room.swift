//
//  Room.swift
//  LabyrinthGame
//
//  Created by Aknazar Sherniiazov on 4/7/25.
//

import Foundation

enum RoomType { case normal, dark }

class Room {
    let baseDescription: String
    var doors: [Direction]
    var items: [Item]
    var type: RoomType
    var hasChest: Bool = false
    
    init(doors: [Direction],
         items: [Item] = [],
         type: RoomType = .normal
    ) {
        
        self.baseDescription = "room"
        self.doors = doors
        self.items = items
        self.type = type
    }
    
    private func standardDescription() -> String {
        var lines = [baseDescription]
        
        if !doors.isEmpty {
            let dirs = doors.map(\.rawValue).joined(separator: ", ")
            lines.append(Color.yellow.wrap("Doors: \(dirs)"))
        }
        
        if !items.isEmpty {
            let names = items.map(\.name).joined(separator: ", ")
            lines.append(Color.green.wrap("You see here: \(names)"))
        }
        
        if hasChest { lines.append(Color.green.wrap("There is a chest here.")) }
        
        return lines.joined(separator: "\n")
    }
    
    func description(for player: Player) -> String {
        if type == .dark && !player.has(item: .torchlight) {
            return "darkness"
        }
        return standardDescription()
    }
}
