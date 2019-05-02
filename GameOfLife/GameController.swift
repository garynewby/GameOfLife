//
//  GameController.swift
//  GameOfLife
//
//  Created by Gary Newby on 5/2/19.
//  Copyright © 2019 Gary Newby. All rights reserved.
//

import UIKit

protocol GameControllerDelegate: AnyObject {
    func updateIterationsLabel(text: String)
}

class GameController {
    weak var delegate: GameControllerDelegate?
    var view: UIView
    var cellViewArray: [CellView] = []
    var cellViewInnerArray: [CellView] = []
    var generation: Int = 0
    var displayLink: CADisplayLink?
    let columns: Int = 50
    let rows: Int = 63
    let cellSpace: CGFloat = 2.0

    static let aliveColour: UIColor = UIColor(white: 0.9, alpha: 1.0)
    static let deadColour: UIColor = UIColor(white: 0.1, alpha: 1.0)

    init(view: UIView, delegate: GameControllerDelegate) {
        self.view = view
        self.delegate = delegate
        //initDisplayLink()
        addCells()
    }

    func addCells() {
        cellViewArray = []
        cellViewInnerArray = []

        let cellSize = (view.bounds.width - ((CGFloat(columns) - 1) * cellSpace) - 20.0) / CGFloat(columns)
        var cellCount = 0
        var cellCountInner = 0
        for r in 0..<rows {
            for c in 0..<columns {
                let cellView = CellView(frame: CGRect(x: 10 + (CGFloat(c) * (cellSize + cellSpace)), y: 20 + (CGFloat(r) * (cellSize + self.cellSpace)), width: cellSize, height: cellSize), index: cellCount, columns: columns)
                cellViewArray.append(cellView)
                cellView.backgroundColor = view.backgroundColor
                if insideBorder(row: r, column: c) {
                    cellViewInnerArray.append(cellView)
                    cellCountInner += 1
                    cellView.backgroundColor = GameController.deadColour
                }
                view.addSubview(cellView)
                cellCount += 1
            }
        }
    }

    func insideBorder(row: Int, column: Int) -> Bool {
        return (row > 0 && row < (rows - 1) && column >= 1 && column < (columns - 1))
    }

    // Mark - Loop

    @objc func gameLoop() {
        cellViewInnerArray.forEach { checkLifeState(cellView: $0) }
        cellViewInnerArray.forEach { updateLifeState(cellView: $0) }
        delegate?.updateIterationsLabel(text: "Iteration: \(generation)")
        generation += 1;
    }

    func newGame(randomise: Bool) {
        for cellView in cellViewInnerArray {
            cellView.backgroundColor = GameController.deadColour
            cellView.alive = false
            cellView.alivePrePass = false
            if (randomise && arc4random_uniform(3) == 0) {
                cellView.alive = true
                cellView.backgroundColor = GameController.aliveColour
            }
        }
        generation = 0
        delegate?.updateIterationsLabel(text: "Iteration: \(generation)")
        continueGame()
    }

    func continueGame() {
        if displayLink != nil {
            return;
        }
        initDisplayLink()
    }

    func initDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(gameLoop))
        //displayLink?.preferredFramesPerSecond = 30
        displayLink?.add(to: RunLoop.main, forMode: .default)
    }

    func stopGame() {
        displayLink?.invalidate()
        displayLink = nil
    }

    func checkLifeState(cellView: CellView) {
        var liveNeighbouringCellCount = 0;
        for index in cellView.matrixArray {
            liveNeighbouringCellCount += checkCellAt(index: index);
        }
        // Any live cell with fewer than two live neighbours dies, as if caused by under-population
        if (cellView.alive && liveNeighbouringCellCount < 2) {
            cellView.alivePrePass = false;
            cellView.age = 0;
        }
        // Any live cell with two or three live neighbours lives on to the next generation
        if (cellView.alive && (liveNeighbouringCellCount == 2 || liveNeighbouringCellCount == 3)) {
            cellView.alivePrePass = true;
            cellView.age += 1
        }
        // Any live cell with more than three live neighbours dies, as if by overcrowding
        if (cellView.alive && liveNeighbouringCellCount > 3) {
            cellView.alivePrePass = false;
            cellView.age = 0;
        }
        // Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction
        if (!cellView.alive && liveNeighbouringCellCount == 3) {
            cellView.alivePrePass = true;
            cellView.age = 0;
        }
    }

    func updateLifeState(cellView: CellView) {
        cellView.alive = cellView.alivePrePass;
        cellView.backgroundColor = cellView.alive ? UIColor(hue: (CGFloat(cellView.age) * 0.01), saturation: 0.7, brightness: 0.8, alpha: 1.0) : GameController.deadColour
    }

    func checkCellAt(index: Int) -> Int {
        if index >= cellViewArray.count {
            return 0
        }
        return cellViewArray[index].alive ? 1 : 0
    }
}
