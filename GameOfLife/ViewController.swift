//
//  ViewController.swift
//  GameOfLife
//
//  Created by Gary Newby on 5/2/19.
//  Copyright © 2019 Gary Newby. All rights reserved.
//

import SpriteKit

class ViewController: UIViewController {
    @IBOutlet weak var cellsView: SKView!
    @IBOutlet weak var pauseButton: UIButton!
    private var gameController: GameScene?
    private var isPaused = false

    override func viewDidLoad() {
        super.viewDidLoad()
        gameController = GameScene(cellsView: cellsView)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func newTapped(_ sender: Any) {
        gameController?.newGame(randomise: true)
    }

    @IBAction func pauseTapped(_ sender: Any) {
        isPaused.toggle()
        gameController?.pauseGame(value: isPaused)
        pauseButton.setTitle(isPaused ? "Continue" : "Pause", for: .normal)
    }
}

