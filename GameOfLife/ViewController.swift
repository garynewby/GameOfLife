//
//  ViewController.swift
//  GameOfLife
//
//  Created by Gary Newby on 5/2/19.
//  Copyright © 2019 Gary Newby. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GameControllerDelegate {
    @IBOutlet weak var iterationLabel: UILabel!
    private var gameController: GameController?

    override func viewDidLoad() {
        super.viewDidLoad()
        gameController = GameController(view: view, delegate: self)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func newTapped(_ sender: Any) {
        gameController?.newGame(randomise: true)
    }

    @IBAction func continueTapped(_ sender: Any) {
        gameController?.continueGame()
    }

    @IBAction func stopTapped(_ sender: Any) {
        gameController?.stopGame()
    }

    // Mark - GameControllerDelegate

    func updateIterationsLabel(text: String) {
        iterationLabel.text = text
    }

}

