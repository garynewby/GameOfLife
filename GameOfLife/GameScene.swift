//
//  GameController.swift
//  GameOfLife
//
//  Created by Gary Newby on 5/2/19.
//  Copyright © 2019 Gary Newby. All rights reserved.
//

import SpriteKit

final class GameScene: SKScene {
    private var cellsView: SKView
    private var cellViewArray: [CellView] = []
    private var cellViewInnerArray: [CellView] = []
    private var generation: Int = 0
    private var rows: Int = 0
    private let cellSpace: CGFloat = 1.0
    private let columns: Int
    private let cameraNode = SKCameraNode()

    static let backColour: UIColor = UIColor.black
    static let aliveColour: UIColor = UIColor(white: 1.0, alpha: 1.0)
    static let deadColour: UIColor = UIColor(white: 0.25, alpha: 1.0)

    init(cellsView: SKView) {
        self.cellsView = cellsView
        columns = UIDevice.current.userInterfaceIdiom == .pad ? 46 : 30 // add 2 columns for L/R borders
        super.init(size: cellsView.bounds.size)
        addCells()

        cellsView.presentScene(scene)
        cellsView.preferredFramesPerSecond = 25
        cellsView.isPaused = false

        backgroundColor = GameScene.backColour
        cameraNode.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        addChild(cameraNode)
        camera = cameraNode
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addCells() {
        let cellSize = (cellsView.bounds.width - (cellSpace * CGFloat(columns - 1))) / CGFloat(columns)
        rows = Int((cellsView.bounds.height) / (cellSize + cellSpace))

        cellViewArray = []
        cellViewInnerArray = []
        var cellCount = 0
        var cellCountInner = 0

        for r in 0..<rows {
            for c in 0..<columns {
                let frame = CGRect(x: (CGFloat(c) * (cellSize + cellSpace)), y: (CGFloat(r) * (cellSize + self.cellSpace)), width: cellSize, height: cellSize)
                let cellView = CellView(frame: frame, index: cellCount, columns: columns)
                cellViewArray.append(cellView)
                cellView.fillColor = GameScene.backColour
                if insideBorder(row: r, column: c) {
                    cellViewInnerArray.append(cellView)
                    cellCountInner += 1
                }
                addChild(cellView)
                cellCount += 1
            }
        }
    }

    private func insideBorder(row: Int, column: Int) -> Bool {
        return (row > 0 && row < (rows - 1) && column >= 1 && column < (columns - 1))
    }

    // MARK: - Game loop

    override func update(_ currentTime: TimeInterval) {
        cellViewInnerArray.forEach { checkLifeState(cellView: $0) }
        cellViewInnerArray.forEach { updateLifeState(cellView: $0) }
        generation += 1;
    }

    func newGame(randomise: Bool) {
        for cellView in cellViewInnerArray {
            cellView.fillColor = GameScene.deadColour
            cellView.alive = false
            cellView.alivePrePass = false
            if (randomise && arc4random_uniform(2) == 0) {
                cellView.alive = true
                cellView.fillColor = GameScene.aliveColour
            }
        }
        generation = 0
        cameraNode.run(SKAction.sequence([
            SKAction.group([SKAction.fadeOut(withDuration: 0.25), SKAction.scale(to: 1.1, duration: 0.25)]),
            SKAction.group([SKAction.scale(to: 1.0, duration: 0.25), SKAction.fadeIn(withDuration: 0.25)])]))
        {
            self.cellsView.isPaused = false
        }
    }

    func pauseGame(value: Bool) {
        cellsView.isPaused = value
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
        cellView.fillColor = cellView.alive ? UIColor(hue: (CGFloat(cellView.age) * 0.03), saturation: 1.0, brightness: 1.0, alpha: 1.0) : GameScene.deadColour
    }

    private func checkCellIsAliveAt(index: Int) -> Int {
        if index >= cellViewArray.count {
            return 0
        }
        return cellViewArray[index].alive ? 1 : 0
    }
}
