//
//  GameModel.swift
//  GameOfLife
//
//  Created by Gary Newby on 8/28/19.
//

import Foundation

final class GameSceneModel {
    
    var cellViewArray: [CellViewModel] = []
    var cellViewInnerArray: [CellViewModel] = []
    var generation: Int = 0
    var rows: Int = 0
    var columns: Int

    init(isIPad: Bool) {
        columns = isIPad ? 44 : 28
        columns += 2// add 2 columns for left/right borders
    }
    
    func newGame() {
        cellViewInnerArray.forEach {
            $0.age = 0
            $0.alive = arc4random_uniform(2) == 0 ? true :false
            $0.alivePrePass = false
        }
        generation = 0
    }

    func checkLifeState(cellState: CellViewModel) {
        func checkCellIsAliveAt(index: Int) -> Bool {
            if index >= cellViewArray.count {
                return false
            }
            return cellViewArray[index].alive
        }
        var liveNeighbouringCellCount = 0
        for index in cellState.matrixArray {
            liveNeighbouringCellCount += (checkCellIsAliveAt(index: index) ? 1 : 0)
        }
        // Any live cell with fewer than two live neighbours dies, as if caused by under-population
        if (cellState.alive && liveNeighbouringCellCount < 2) {
            cellState.alivePrePass = false
            cellState.age = 0
        }
        // Any live cell with two or three live neighbours lives on to the next generation
        if (cellState.alive && (liveNeighbouringCellCount == 2 || liveNeighbouringCellCount == 3)) {
            cellState.alivePrePass = true
            cellState.age += 1
        }
        // Any live cell with more than three live neighbours dies, as if by overcrowding
        if (cellState.alive && liveNeighbouringCellCount > 3) {
            cellState.alivePrePass = false
            cellState.age = 0
        }
        // Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction
        if (!cellState.alive && liveNeighbouringCellCount == 3) {
            cellState.alivePrePass = true
            cellState.age = 0
        }
    }

    func addInnerCell(cellState: CellViewModel, row: Int, column: Int) {
        if row > 0 && row < (rows - 1) && column >= 1 && column < (columns - 1) {
            cellViewInnerArray.append(cellState)
        }
    }
}
