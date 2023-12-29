//
//  ViewController.swift
//  GameOfLife
//
//  Created by Gary Newby on 5/2/19.
//

import SpriteKit

class ViewController: UIViewController {

    private var gameScene: GameScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newButton = UIButton(type: .system, primaryAction: UIAction(title: "New", handler: { [weak self] _ in
            self?.gameScene?.newGame()
        }))
        
        newButton.setTitleColor(.white, for: .normal)
        newButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        let pauseButton = UIButton(type: .system, primaryAction: UIAction(title: "Pause", handler: { [weak self] action in
            self?.gameScene?.togglePaused()
            (action.sender as? UIButton)?.setTitle(self?.gameScene?.title, for: .normal)
        }))
        
        pauseButton.setTitleColor(.white, for: .normal)
        pauseButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)

        let buttonStackView = UIStackView(arrangedSubviews: [newButton, pauseButton])
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually

        let cellsView = SKView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        cellsView.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [cellsView, buttonStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        let viewModel = GameSceneModel(isIPad: UIDevice.current.userInterfaceIdiom == .pad)
        gameScene = GameScene(cellsView: cellsView, viewModel: viewModel)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
