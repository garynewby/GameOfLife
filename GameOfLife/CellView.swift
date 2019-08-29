//
//  CellView.swift
//  GameOfLife
//
//  Created by Gary Newby on 5/2/19.
//  Copyright © 2019 Gary Newby. All rights reserved.
//

import SpriteKit

protocol CellViewDelegate: AnyObject {
    func cellViewDidToggleAlive(_ cellView: CellView)
}

final class CellView: SKShapeNode {
    weak var delegate: CellViewDelegate?

    init(frame: CGRect) {
        super.init()
        self.path = CGPath(ellipseIn: frame, transform: nil)
        isUserInteractionEnabled = true
        lineWidth = 0
        fillColor = GameScene.deadColour
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.cellViewDidToggleAlive(self)
    }
}
