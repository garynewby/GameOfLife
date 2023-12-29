//
//  GameModel.swift
//  GameOfLife
//
//  Created by Gary Newby on 8/20/19
//

import UIKit

class CellViewModel: CellViewDelegate {
    
    var age: Int
    var matrixArray: [Int]
    var view: CellView
    var alivePrePass: Bool
    var alive: Bool {
        didSet {
            view.fillColor = alive ? UIColor(hue: (CGFloat(age) * 0.03), saturation: 1.0, brightness: 1.0, alpha: 1.0) : GameScene.deadColour
        }
    }

    init(age: Int, alive: Bool, alivePrePass: Bool, matrixArray: [Int], view: CellView) {
        self.age = age
        self.alive = alive
        self.alivePrePass = alivePrePass
        self.matrixArray = matrixArray
        self.view = view
        self.view.delegate = self
    }

    // MARK: - CellViewDelegate

    func cellViewDidToggleAlive(_ cellView: CellView) {
        alive.toggle()
    }

}
