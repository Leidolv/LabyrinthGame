//
//  Items.swift
//  LabyrinthGame
//
//  Created by Aknazar Sherniiazov on 4/7/25.
//

enum Item: Equatable {
    case key
    case torchlight
    case gold(amount: Int)
    case food
    
    var name: String {
        switch self {
        case .key: return "Key"
        case .torchlight: return "Torchlight"
        case .gold: return "Gold"
        case .food: return "Food"
        }
    }
}

extension Item {
    init?(named raw: String) {
        switch raw.lowercased() {
        case "key": self = .key
        case "torch", "torchlight": self = .torchlight
        case "food": self = .food
        case "gold": self = .gold(amount: 100)
        default: return nil
        
        }
    }
}





