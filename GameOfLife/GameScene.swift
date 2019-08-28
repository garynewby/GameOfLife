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
    private let cellSpace: CGFloat = 1.0
    private let cameraNode = SKCameraNode()
    private var model = GameModel()
    static let backColour: UIColor = UIColor.black
    static let aliveColour: UIColor = UIColor(white: 1.0, alpha: 1.0)
    static let deadColour: UIColor = UIColor(white: 0.25, alpha: 1.0)

    init(cellsView: SKView) {
        self.cellsView = cellsView
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
        let columns = model.columns
        let cellSize = (cellsView.bounds.width - (cellSpace * CGFloat(columns - 1))) / CGFloat(columns)
        let rows = Int((cellsView.bounds.height) / (cellSize + cellSpace))
        model.rows = rows
        var cellCount = 0

        for row in 0..<rows {
            for column in 0..<columns {
                let frame = CGRect(x: (CGFloat(column) * (cellSize + cellSpace)), y: (CGFloat(row) * (cellSize + self.cellSpace)), width: cellSize, height: cellSize)
                let cellView = CellView(frame: frame)
                let matrixArray: [Int] = [(cellCount - (columns + 1)), (cellCount - columns), (cellCount - (columns-1)), (cellCount + 1), (cellCount + (columns + 1)), (cellCount + columns), (cellCount + (columns-1)), (cellCount - 1)]
                let cellState = CellState(age: 0, alive: false, alivePrePass: false, matrixArray: matrixArray, view: cellView)

                model.cellViewArray.append(cellState)
                cellView.fillColor = GameScene.backColour

                if insideBorder(row: row, column: column) {
                    model.cellViewInnerArray.append(cellState)
                }

                addChild(cellView)
                cellCount += 1
            }
        }
    }

    private func insideBorder(row: Int, column: Int) -> Bool {
        return (row > 0 && row < (model.rows - 1) && column >= 1 && column < (model.columns - 1))
    }

    // MARK: - Game loop

    override func update(_ currentTime: TimeInterval) {
        model.cellViewInnerArray.forEach { model.checkLifeState(cellState: $0) }
        model.cellViewInnerArray.forEach { $0.alive = $0.alivePrePass }
        model.generation += 1
    }

    func newGame() {
        model.cellViewInnerArray.forEach {
            $0.age = 0
            $0.alive = arc4random_uniform(2) == 0 ? true :false
            $0.alivePrePass = false
        }
        model.generation = 0

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

}
