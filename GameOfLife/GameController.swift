//
//  GameController.swift
//  GameOfLife
//
//  Created by Gary Newby on 5/2/19.
//  Copyright © 2019 Gary Newby. All rights reserved.
//

import SpriteKit

protocol GameControllerDelegate: AnyObject {
    func updateIterationsLabel(text: String)
}

final class GameController {
    private var scene: SKScene?
    private weak var delegate: GameControllerDelegate?
    private var cellsView: SKView
    private var cellViewArray: [CellView] = []
    private var cellViewInnerArray: [CellView] = []
    private var generation: Int = 0
    private var displayLink: CADisplayLink?
    private var rows: Int = 0
    private let cellSpace: CGFloat = 1.0
    private let columns: Int

    static let aliveColour: UIColor = UIColor(white: 0.90, alpha: 1.0)
    static let deadColour: UIColor = UIColor(white: 0.10, alpha: 1.0)

    init(cellsView: SKView, delegate: GameControllerDelegate) {
        self.cellsView = cellsView
        self.delegate = delegate

        scene = SKScene(size: cellsView.bounds.size)
        if let scene = scene {
            cellsView.presentScene(scene)
        }
        
        columns = UIDevice.current.userInterfaceIdiom == .pad ? 44 + 2 : 22 + 2 // add 2 columns for L/R borders
        addCells()
    }

    private func addCells() {
        cellViewArray = []
        cellViewInnerArray = []
        let cellSize = (cellsView.bounds.width - (cellSpace * CGFloat(columns - 3))) / CGFloat(columns - 2)
        var cellCount = 0
        var cellCountInner = 0
        rows = Int(((cellsView.bounds.height - cellSpace) / (cellSize + cellSpace)).rounded(.up))

        for r in 0..<rows {
            for c in 0..<columns {
                let frame = CGRect(x: (CGFloat(c) * (cellSize + cellSpace)) - cellSize, y: (CGFloat(r) * (cellSize + self.cellSpace)) - cellSize, width: cellSize, height: cellSize)
                let cellView = CellView(frame: frame, index: cellCount, columns: columns)
                cellViewArray.append(cellView)
                cellView.fillColor = UIColor.green
                //cellView.fillColor = cellsView.fillColor
                if insideBorder(row: r, column: c) {
                    cellViewInnerArray.append(cellView)
                    cellCountInner += 1
                    cellView.fillColor = GameController.deadColour
                }
                scene?.addChild(cellView)
                cellCount += 1
            }
        }
    }

    private func insideBorder(row: Int, column: Int) -> Bool {
        return (row > 0 && row < (rows - 1) && column >= 1 && column < (columns - 1))
    }

    // MARK: - Loop

    @objc private func gameLoop() {
        cellViewInnerArray.forEach { checkLifeState(cellView: $0) }
        cellViewInnerArray.forEach { updateLifeState(cellView: $0) }
        updateLabel()
        generation += 1;
    }

    func newGame(randomise: Bool) {
        for cellView in cellViewInnerArray {
            cellView.fillColor = GameController.deadColour
            cellView.alive = false
            cellView.alivePrePass = false
            if (randomise && arc4random_uniform(3) == 0) {
                cellView.alive = true
                cellView.fillColor = GameController.aliveColour
            }
        }
        generation = 0
        updateLabel()
        continueGame()
    }

    func updateLabel() {
        delegate?.updateIterationsLabel(text: "Generation: \(generation)")
    }

    func continueGame() {
        if displayLink != nil {
            return;
        }
        initDisplayLink()
    }

    func stopGame() {
        displayLink?.invalidate()
        displayLink = nil
    }

    private func initDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(gameLoop))
        displayLink?.preferredFramesPerSecond = 15
        displayLink?.add(to: RunLoop.main, forMode: .default)
    }

    private func checkLifeState(cellView: CellView) {
        var liveNeighbouringCellCount = 0;
        for index in cellView.matrixArray {
            liveNeighbouringCellCount += checkCellIsAliveAt(index: index);
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

    private func updateLifeState(cellView: CellView) {
        cellView.alive = cellView.alivePrePass;
        cellView.fillColor = cellView.alive ? UIColor(hue: (CGFloat(cellView.age) * 0.03), saturation: 1.0, brightness: 1.0, alpha: 1.0) : GameController.deadColour
    }

    private func checkCellIsAliveAt(index: Int) -> Int {
        if index >= cellViewArray.count {
            return 0
        }
        return cellViewArray[index].alive ? 1 : 0
    }
}
