//
//  CellView.swift
//  GameOfLife
//
//  Created by Gary Newby on 5/2/19.
//  Copyright © 2019 Gary Newby. All rights reserved.
//

import SpriteKit

final class CellView: SKShapeNode {
    var index: Int = 0
    var age: Int = 0
    var alive: Bool = false;
    var alivePrePass: Bool = false;
    var matrixArray: [Int] = []

    init(frame: CGRect, index: Int, columns: Int) {
        super.init()
        self.index = index;
        self.path = CGPath(ellipseIn: frame, transform: nil)
        isUserInteractionEnabled = true
        fillColor = GameScene.deadColour
        lineWidth = 0
        matrixArray = [(index - (columns + 1)), (index - columns), (index - (columns-1)), (index + 1),
                       (index + (columns + 1)), (index + columns), (index + (columns-1)), (index - 1)]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        alive.toggle()
        fillColor = alive ? GameScene.aliveColour : GameScene.deadColour
    }
}
