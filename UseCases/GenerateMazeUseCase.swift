//
//  GenerateMazeUseCase.swift
//  LabyrinthGame
//
//  Created by Aknazar Sherniiazov on 4/7/25.
//

import Foundation

struct GenerateMazeUseCase {
    func execute(width: Int, height: Int, steps: Int) -> (grid: [[Room]], player: Player) {
        let grid = MazeGenerator.generate(width: width, height: height)
        let player = Player(startX: 0, startY: 0, steps: steps)

        return (grid, player)
    }
}
