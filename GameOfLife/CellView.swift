//
//  CellView.swift
//  GameOfLife
//
//  Created by Gary Newby on 5/2/19.
//  Copyright © 2019 Gary Newby. All rights reserved.
//

import UIKit

class CellView: UIView {
    private var index: Int
    private var tapRecognizer: UITapGestureRecognizer?
    var age: Int = 0
    var alive: Bool = false;
    var alivePrePass: Bool = false;
    var matrixArray: [Int]

    init(frame: CGRect, index: Int, columns: Int) {
        self.index = index;
        matrixArray = [(index - (columns + 1)), (index - columns), (index - (columns-1)), (index + 1), (index + (columns+1)), (index + columns), (index + (columns-1)), (index - 1)]
        super.init(frame: frame)
        isUserInteractionEnabled = true
        isOpaque = true
        backgroundColor = GameController.deadColour
        layer.cornerRadius = frame.size.width/2.0
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleLive))
        if let tapRecognizer = tapRecognizer  {
            addGestureRecognizer(tapRecognizer)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        if let tapRecognizer = tapRecognizer  {
            removeGestureRecognizer(tapRecognizer)
        }
    }

    @objc private func toggleLive() {
        alive.toggle()
        backgroundColor = alive ? GameController.aliveColour : GameController.deadColour
    }
}
