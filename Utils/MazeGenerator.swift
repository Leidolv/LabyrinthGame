//
//  MazeGenerator.swift
//  LabyrinthGame
//
//  Created by Aknazar Sherniiazov on 4/7/25.
//

import Foundation

struct MazeGenerator {
    static func generate(width: Int, height: Int) -> [[Room]] {
        var grid: [[Room]] = []
        
        for y in 0..<height {
            var row: [Room] = []
            for x in 0..<width {
                let allDirs = Direction.allCases.filter { dir in
                    switch dir {
                    case .north: return y > 0
                    case .south: return y < height - 1
                    case .west: return x > 0
                    case .east: return x < width - 1
                    }
                }
                let room = Room(doors: allDirs)
                row.append(room)
            }
            grid.append(row)
        }
        
        let randX = Int.random(in: 0..<width)
        let randY = Int.random(in: 0..<height)
        grid[randY][randX].hasChest = true
        
        let totalRooms = width * height
        let darkRoomsCount = max(1, totalRooms / 4)
        
        var candidates: [(x: Int, y: Int)] = []
        for y in 0..<height {
            for x in 0..<width {
                if x == 0 && y == 0 { continue }
                candidates.append((x, y))
            }
        }
        
        candidates.shuffle()
        
        for i in 0..<darkRoomsCount {
            let (x, y) = candidates[i]
            grid[y][x].type = .dark
        }
        
        let allRooms = grid.flatMap { $0 }
        let hasTorch = allRooms.contains { room in
            room.items.contains { $0 == .torchlight }
        }
        
        if !hasTorch {
            if let torchRoom = candidates.first(where: { grid[$0.y][$0.x].type != .dark }) {
                grid[torchRoom.y][torchRoom.x].items.append(.torchlight)
            } else if let randomRoom = candidates.first {
                grid[randomRoom.y][randomRoom.x].items.append(.torchlight)
            }
        }
       
        let itemsToPlace: [Item] = [.key, .food, .gold(amount: 5)]
        
        var freeCells = (0..<height).flatMap { y in
            (0..<width).compactMap { x in
                (x == 0 && y == 0) ? nil : (x, y)
            }
        }.shuffled()
        
        for item in itemsToPlace where !freeCells.isEmpty {
            let (x, y) = freeCells.removeLast()
            grid[y][x].items.append(item)
        }
        
        return grid
    }
}
