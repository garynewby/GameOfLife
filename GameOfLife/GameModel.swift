//
//  GameModel.swift
//  GameOfLife
//
//  Created by Gary Newby on 8/28/19.
//  Copyright © 2019 Gary Newby. All rights reserved.
//

import UIKit

final class GameModel {
    var cellViewArray: [CellState] = []
    var cellViewInnerArray: [CellState] = []
    var generation: Int = 0
    var rows: Int = 0
    var columns: Int

    init() {
        // add 2 columns for left/right borders
        columns = UIDevice.current.userInterfaceIdiom == .pad ? 46 : 30
    }

    func checkLifeState(cellState: CellState) {
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

}
