//
//  GameCommand.swift
//  LabyrinthGame
//
//  Created by Aknazar Sherniiazov on 9/7/25.
//
import Foundation

enum GameCommand {
    case move(Direction)
    case eat(String)
    case drop(String)
    case get(String)
    case open
    case items
    case unknown
    
    static func parse(_ parts: [String]) -> GameCommand {
        guard let first = parts.first?.lowercased() else { return unknown }
        
        switch first {
        case "n", "s", "w", "e":
            return Direction(rawValue: first.uppercased())
                .map(GameCommand.move) ?? .unknown
            
        case "eat" where parts.count >= 2: return .eat(parts[1])
        case "drop" where parts.count >= 2: return .drop(parts[1])
        case "get" where parts.count >= 2: return .get(parts.dropFirst().joined(separator: " "))
        case "open": return .open
        case "items": return .items
        default: return .unknown
        }
    }
}
