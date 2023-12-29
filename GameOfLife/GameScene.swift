//
//  GameController.swift
//  GameOfLife
//
//  Created by Gary Newby on 5/2/19.
//

import SpriteKit

final class GameScene: SKScene {
    
    private var cellsView: SKView
    private let cellSpace: CGFloat = 1.0
    private let cameraNode = SKCameraNode()
    private let viewModel: GameSceneModel
    static let backColour: UIColor = UIColor.black
    static let aliveColour: UIColor = UIColor(white: 1.0, alpha: 1.0)
    static let deadColour: UIColor = UIColor(white: 0.25, alpha: 1.0)
   
    var title: String {
        return cellsView.isPaused ? "Continue" : "Pause"
    }

    init(cellsView: SKView, viewModel: GameSceneModel) {
        self.viewModel = viewModel
        self.cellsView = cellsView
        super.init(size: cellsView.bounds.size)
        
        addCells()
        
        cellsView.presentScene(scene)
        cellsView.preferredFramesPerSecond = 15
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
        let columns = viewModel.columns
        let cellSize = (cellsView.bounds.width - (cellSpace * CGFloat(columns - 1))) / CGFloat(columns)
        let rows = Int((cellsView.bounds.height) / (cellSize + cellSpace))
        viewModel.rows = rows
        var cellCount = 0

        for row in 0..<rows {
            for column in 0..<columns {
                let frame = CGRect(x: (CGFloat(column) * (cellSize + cellSpace)), y: (CGFloat(row) * (cellSize + self.cellSpace)), width: cellSize, height: cellSize)
                let cellView = CellView(frame: frame)
                let matrixArray: [Int] = [(cellCount - (columns + 1)), (cellCount - columns), (cellCount - (columns-1)), (cellCount + 1), (cellCount + (columns + 1)), (cellCount + columns), (cellCount + (columns-1)), (cellCount - 1)]
                let cellState = CellViewModel(age: 0, alive: false, alivePrePass: false, matrixArray: matrixArray, view: cellView)

                viewModel.cellViewArray.append(cellState)
                cellView.fillColor = GameScene.backColour

                viewModel.addInnerCell(cellState: cellState, row: row, column: column)
                addChild(cellView)
                cellCount += 1
            }
        }
    }

    // MARK: - Game loop

    override func update(_ currentTime: TimeInterval) {
        viewModel.cellViewInnerArray.forEach { viewModel.checkLifeState(cellState: $0) }
        viewModel.cellViewInnerArray.forEach { $0.alive = $0.alivePrePass }
        viewModel.generation += 1
    }

    func newGame() {
        viewModel.newGame()
        cameraNode.run(SKAction.sequence([
            SKAction.group([SKAction.fadeOut(withDuration: 0.25), SKAction.scale(to: 1.1, duration: 0.25)]),
            SKAction.group([SKAction.scale(to: 1.0, duration: 0.25), SKAction.fadeIn(withDuration: 0.25)])]))
        {
            self.cellsView.isPaused = false
        }
    }

    func togglePaused() {
        cellsView.isPaused.toggle()
    }
}
