//
//  ConsoleView.swift
//  LabyrinthGame
//
//  Created by Aknazar Sherniiazov on 4/7/25.
//
import Foundation

class ConsoleView {
    func showRoom(_ room: Room, player: Player) {
        let fullDesc = room.description(for: player)
        let firstLine = fullDesc.components(separatedBy: "\n").first ?? fullDesc
        let restLines = fullDesc.dropFirst(firstLine.count + 1)
        print(Color.cyan.wrap("You are in the \(firstLine) [\(player.x), \(player.y)]."))
        if !restLines.isEmpty {
            print(Color.cyan.wrap(String(restLines)))
        }
        print(Color.yellow.wrap("Steps left: \(player.stepsRemaining)\n"))
    }
    
    func prompt() -> String? {
        print(Color.yellow.wrap("Enter command:"), terminator: " ")
        return readLine()
    }
    
    func showMessage(_ text: String) {
        print(text)
    }
}

enum Color: String {
    case reset  = "\u{001B}[0m"
    case red    = "\u{001B}[31m"
    case green  = "\u{001B}[32m"
    case yellow = "\u{001B}[33m"
    case cyan   = "\u{001B}[36m"

    func wrap(_ text: String) -> String { rawValue + text + Color.reset.rawValue }
}
