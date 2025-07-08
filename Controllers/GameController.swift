//
//  GameController.swift
//  LabyrinthGame
//
//  Created by Aknazar Sherniiazov on 4/7/25.
//

import Foundation

class GameController {
    private let consoleView = ConsoleView()
    private let genUseCase = GenerateMazeUseCase()
    private let moveUseCase = MovePlayerUseCase()
    private let pickUpUseCase = PickUpItemUseCase()
    private let openChestUseCase = OpenChestUseCase()
    
    private var grid: [[Room]] = []
    private var player: Player!
    
    // MARK: - Функция ввода размера лабиринта
    private func askForInt(_ prompt: String, default defaultValue: Int) -> Int {
        print("\(prompt)(default \(defaultValue)): ", terminator: "")
        guard let line = readLine(),
              let v = Int(line.trimmingCharacters(in: .whitespaces)),
              v > 0 else { return defaultValue}
        return v
    }
    
    func run() {
        let width = askForInt("Enter maze width", default: 5)
        let height = askForInt("Enter maze height", default: 5)
        
        let maxSteps = width * height * 2
        
        let (g, p) = genUseCase.execute(width: width, height: height, steps: maxSteps)
        grid = g; player = p
        
        consoleView.showMessage(Color.yellow.wrap("Maze \(width)*\(height) created. Available steps: \(maxSteps)."))
        
        while true {
            let room = grid[player.y][player.x]
            consoleView.showRoom(room, player: player)
            
            guard let line = consoleView.prompt() else { continue }
            
            let cleaned = line.unicodeScalars
                .filter { $0.isASCII && !CharacterSet.controlCharacters.contains($0) }
                .map { Character($0) }
            let parts = String(cleaned).split(separator: " ").map(String.init)
            guard let _ = parts.first else { continue }
                
            
            switch GameCommand.parse(parts) {
            case .move(let dir):
                if moveUseCase.execute(direction: dir, player: player, grid: grid) == false {
                    consoleView.showMessage(Color.red.wrap("You can't go that way"))
                }
                
            case .eat(let name):
                guard let item = Item(named: name), item == .food else {
                    consoleView.showMessage(Color.yellow.wrap("You can only eat food."))
                    break
                }
                
                let room = grid[player.y][player.x]
                if let idx = room.items.firstIndex(of: .food) {
                    room.items.remove(at: idx)
                    consoleView.showMessage(Color.green.wrap("You ate the food and feel refreshed!"))
                } else {
                    consoleView.showMessage(Color.red.wrap("There is no food here."))
                    break
                }
                player.stepsRemaining += 5
                grid[player.y][player.x] = room
                
            case .drop(let name):
                guard let item = Item(named: name) else {
                    consoleView.showMessage(Color.yellow.wrap("Unknown item: \(name)"))
                    break
                }
                if let idx = player.inventory.firstIndex(of: item) {
                    player.inventory.remove(at: idx)
                    grid[player.y][player.x].items.append(item)
                    consoleView.showMessage(Color.yellow.wrap("Dropped \(item.name)."))
                } else {
                    consoleView.showMessage(Color.red.wrap("You don't have \(item.name)."))
                }
                
            case .get(let rawName):
                if pickUpUseCase.execute(itemName: rawName, player: player, grid: &grid) {
                    let list = player.inventory.map(\.name).joined(separator: ", ")
                    consoleView.showMessage(Color.green.wrap("Picked up \(rawName). You have items: [\(list.isEmpty ? "none" : list)]"))
                } else {
                    consoleView.showMessage(Color.red.wrap("No such item here."))
                }
                
            case .open:
                if openChestUseCase.execute(player: player, grid: grid) {
                    consoleView.showMessage(Color.green.wrap("You found the Grail! You win!"))
                    return
                } else {
                    consoleView.showMessage(Color.red.wrap("Nothing to open or you have no key."))
                }
                
            case .items:
                let list = player.inventory.map(\.name).joined(separator: ", ")
                consoleView.showMessage(list.isEmpty ? Color.red.wrap("You don't have items.") : Color.green.wrap("You have: \(list)"))
            
            case .unknown:
                consoleView.showMessage(Color.red.wrap("Unknown command. Try again."))
            }
            
            if player.stepsRemaining <= 0 {
                consoleView.showMessage(Color.red.wrap("You starved in the dungeon. Game over."))
                return
            }
        }
    }
}
