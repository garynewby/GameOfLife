//
//  ViewController.swift
//  GameOfLife
//
//  Created by Gary Newby on 5/2/19.
//  Copyright © 2019 Gary Newby. All rights reserved.
//

import SpriteKit

class ViewController: UIViewController {
    @IBOutlet private weak var cellsView: SKView!
    @IBOutlet private weak var pauseButton: UIButton!
    private var gameScene: GameScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        gameScene = GameScene(cellsView: cellsView, viewModel: GameSceneModel(isIPad: UIDevice.current.userInterfaceIdiom == .pad))
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func newTapped(_ sender: Any) {
        gameScene?.newGame()
    }

    @IBAction func pauseTapped(_ sender: Any) {
        gameScene?.togglePaused()
        pauseButton.setTitle(gameScene?.title, for: .normal)
    }
}
