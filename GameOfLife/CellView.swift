//
//  CellView.swift
//  GameOfLife
//
//  Created by Gary Newby on 5/2/19.
//  Copyright © 2019 Gary Newby. All rights reserved.
//

import SpriteKit

class CellView: SKShapeNode {
    private var index: Int
    private var tapRecognizer: UITapGestureRecognizer?
    var age: Int = 0
    var alive: Bool = false;
    var alivePrePass: Bool = false;
    var matrixArray: [Int]

    init(frame: CGRect, index: Int, columns: Int) {
        self.index = index;
        matrixArray = [(index - (columns + 1)), (index - columns), (index - (columns-1)), (index + 1), (index + (columns+1)), (index + columns), (index + (columns-1)), (index - 1)]
        super.init()
        self.path = CGPath(ellipseIn: frame, transform: nil)
        isUserInteractionEnabled = true
        fillColor = GameController.deadColour
        lineWidth = 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func toggleLive() {
        alive.toggle()
        fillColor = alive ? GameController.aliveColour : GameController.deadColour
    }
}
