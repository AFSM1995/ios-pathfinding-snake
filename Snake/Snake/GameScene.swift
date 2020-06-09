//
//  GameScene.swift
//  Snake
//
//  Created by Álvaro Santillan on 1/8/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//
//  Knwon Bugs
//  Extra valid row on the bottom of the screen.

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // Home screen var`s to store objects
    var gameLogo: SKLabelNode!
    var highScore: SKLabelNode!
    var Algo: SKLabelNode!
    var playPauseButton: SKShapeNode!
    var playButtonTapped = false
    var foodPosition = [CGPoint]()
//    var ttt = [CGPoint]()
//    ttt.append(CGPoint(x: 2, y: 3))

    var playOrPause = false
    var addOrRemoveWall = false
    var snakeColor = UIColor(red:0.75, green:0.22, blue:0.17, alpha:1.00)
    
    // Used to store data and managing user movement.
    var game: GameManager!
    
    
    // Used for storing keystone game information.
    var snakeBodyPos: [(Int, Int)] = []
    var snakeHeadPos: [(Int, Int)] = []
    var algoithimChoice: Int = 0
    var gameScore: SKLabelNode!
    var gameBackground: SKShapeNode!
    var gameBoard: [(node: SKShapeNode, x: Int, y: Int)] = []
    
    // Spritekit vesrion of didLoad() ie gameScene has loaded.
    override func didMove(to view: SKView) {
        initializeWelcomeScreen()
        // Used to store data and managing user movement.
        game = GameManager(scene: self)
        initializeGameView()
        
        if let gameInfo = self.userData?.value(forKey: "playOrNot") {
            playOrPause = gameInfo as! Bool
            snakeColor = gameInfo as! UIColor
        }
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeR))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeL))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeU))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeD))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc func swipeR() {
        game.swipe(ID: 3)
    }
    @objc func swipeL() {
        game.swipe(ID: 1)
    }
    @objc func swipeU() {
        game.swipe(ID: 2)
    }
    @objc func swipeD() {
        game.swipe(ID: 4)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch:UITouch = touches.first!
//        let positionInScene = touch.location(in: self)
//        let touchedNode = self.atPoint(positionInScene)
//
//        let node = touchedNode
//        node.run(SKAction.rotate(byAngle: (CGFloat(M_PI)), duration: 2.0))
        
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if let tappedBalloon = node as? SKSpriteNode {
                    if node.name == "playPauseButton" {
                        if playOrPause == false {
                            playOrPause = true
                            tappedBalloon.texture = SKTexture(imageNamed: "pause-solid.pdf")
                        } else {
                            playOrPause = false
                            tappedBalloon.texture = SKTexture(imageNamed: "play-solid.pdf")
                        }
                    }
                    if node.name == "weightButton" {
                        if addOrRemoveWall == false {
                            addOrRemoveWall = true
                            tappedBalloon.texture = SKTexture(imageNamed: "minus.pdf")
                        } else {
                            addOrRemoveWall = false
                            tappedBalloon.texture = SKTexture(imageNamed: "plus.pdf")
                        }
                    }
                    if node.name == "settingsButton" {
                        print("Settings Tapped")
                    }
                    if node.name == "homeButton" {
                        print("homeButton Tapped")
                    }
//                    node.run(SKAction.rotate(byAngle: (CGFloat(M_PI)), duration: 2.0))
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touc")
        let touch = touches.first
        let location = touch!.location(in: self)
        
        if let touchedNode = selectNodeForTouch(location) {
            let grow = SKAction.scale(by: 1.05, duration: 0.10)
            let shrink = SKAction.scale(by: 0.95, duration: 0.10)
            let wait = SKAction.wait(forDuration: 0.16)
            let scale = SKAction.scale(to: 1.0, duration: 0.12)
            let shrink2 = SKAction.scale(by: 0.97, duration: 0.05)
            let wait2 = SKAction.wait(forDuration: 0.07)
            
//            let shrink3 = SKAction.scale(to: 0.05, duration: 0.15)
            
            if addOrRemoveWall == false {
                touchedNode.fillColor = UserDefaults.standard.colorForKey(key: "Barrier")!
//                touchedNode.name = "Touched"
                touchedNode.run(SKAction.sequence([grow, wait, shrink, wait, scale, shrink2, wait2, scale]))
            } else {
                touchedNode.fillColor = UserDefaults.standard.colorForKey(key: "Unvisited Square")!
                touchedNode.run(SKAction.sequence([grow, wait, shrink, wait, scale, shrink2, wait2, scale]))
//                touchedNode.name = nil
            }
        }
    }
    
    func selectNodeForTouch(_ touchLocation: CGPoint) -> SKShapeNode? {
        let nodes = self.nodes(at: touchLocation)
        for node in nodes {
            if node.name == nil {
                if node is SKShapeNode {
                    return (node as! SKShapeNode)
                }
            }
        }
        return nil
    }
    
    // Welcome menu objects defined
    private func initializeWelcomeScreen() {
        
        let settingsButton = SKSpriteNode(imageNamed: "cog-solid.pdf")
        settingsButton.name = "settingsButton"
        settingsButton.size = CGSize(width: 45, height: 45)
        settingsButton.position = CGPoint(x: 325, y: -170)
        self.addChild(settingsButton)
        
        let homeButton = SKSpriteNode(imageNamed: "home-solid.pdf")
        homeButton.name = "homeButton"
        homeButton.size = CGSize(width: 45, height: 45)
        homeButton.position = CGPoint(x: 270, y: -170)
        self.addChild(homeButton)
        
        let weightButton = SKSpriteNode(imageNamed: "minus.pdf")
        weightButton.name = "weightButton"
        weightButton.size = CGSize(width: 45, height: 45)
        weightButton.position = CGPoint(x: 215, y: -170)
        self.addChild(weightButton)
        
        let playPauseButton = SKSpriteNode(imageNamed: "pause-solid.pdf")
        playPauseButton.name = "playPauseButton"
        playPauseButton.size = CGSize(width: 45, height: 45)
        playPauseButton.position = CGPoint(x: 155, y: -170)
        self.addChild(playPauseButton)
    
        // Define algorithim score label
        Algo = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        Algo.horizontalAlignmentMode = .center
        Algo.position = CGPoint(x: 0, y: 185)
        Algo.zPosition = 1
        Algo.fontSize = 15
        Algo.text = UserDefaults.standard.string(forKey: "Algorithim Choice Name")
        Algo.fontColor = SKColor.white
        // Add to the game scene
        self.addChild(Algo)
        
        // Define best score label
        highScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        highScore.zPosition = 1
        highScore.fontSize = 15
        highScore.text = "High Score: \(UserDefaults.standard.integer(forKey: "highScore"))"
        highScore.fontColor = SKColor.white
        // Add to the game scene
        self.addChild(highScore)
        startGame()
    }
    
    private func initializeGameView() {
        // Create ShapeNode in which the gameboard can reside.
        let rect = CGRect(x: 0-frame.size.width/2, y: 0-frame.size.height/2, width: frame.size.width, height: frame.size.height)
        gameBackground = SKShapeNode(rect: rect, cornerRadius: 0.0)
        gameBackground.fillColor = UIColor.darkGray
        gameBackground.strokeColor = UIColor.darkGray
//        gameBackground.isHidden = true
        self.addChild(gameBackground)
        
        // Create the game board.
        createGameBoard()
    }
    
    var matrix = [[Int]]()
    var row = [Int]()
    // Create a game board, initialize array of cells.
    private func createGameBoard() {
        let width = frame.size.width
        let height = frame.size.height
        
        // Size of square
        let cellWidth: CGFloat = 25
//        let numRows = 41
//        let numCols = 73
        let numRows = 17
        let numCols = 30
        let xx = CGFloat(0 - (Int(cellWidth) * numCols)/2)
        let yy = CGFloat(0 + (Int(cellWidth) * numRows)/2)
        var x = CGFloat(xx + 12.5)
        var y = CGFloat(yy - 12.5)
        
        gameBackground.name = "gameBackground"
        // Loop through rows and columns and create cells.
        for i in 0...numRows - 1 {
            for j in 0...numCols - 1 {
                let cellNode = SKShapeNode.init(rectOf: CGSize(width: cellWidth-1.5, height: cellWidth-1.5), cornerRadius: 3.5)
//                SKShapeNode(rectOf: CGSize(width: cellWidth, height: cellWidth))
                cellNode.fillColor = UserDefaults.standard.colorForKey(key: "Unvisited Square")!
                cellNode.strokeColor = UIColor(red:0.93, green:0.94, blue:0.95, alpha:0.00)
                cellNode.position = CGPoint(x: x, y: y)
                row.append(0)
                // Add to array of cells then add it to the game board.
                gameBoard.append((node: cellNode, x: i, y: j))

                gameBackground.addChild(cellNode)
                x += cellWidth
            }
            matrix.append(row)
            row = [Int]()
            // reset x, iterate y
            x = CGFloat(x - CGFloat(Int(cellWidth) * numCols))
            y -= cellWidth
        }
        // Print Results
        game.bringOvermatrix(tempMatrix: matrix)
    }
    
    // Start the game
    private func startGame() {
        // Move best score label to the bottom of the screen.
        let bottomCorner = CGPoint(x: 0, y: (frame.size.height / -2) + 20)
        highScore.run(SKAction.move(to: bottomCorner, duration: 0.4)) {
//            self.gameBackground.isHidden = false
//            self.gameBackground.fillColor = UIColor.red
            self.game.initiateSnakeStartingPosition()
        }
    }
    
    // Called before each frame is rendered
    // perhapse this can be used to pass in settings? maybe
    
    var called = false
    override func update(_ currentTime: TimeInterval) {
        if game!.fronteerSquareArray.count > 0 && called == false {
            let wait = SKAction.wait(forDuration: 0.0)
            let sequance = SKAction.sequence([wait])
                let node = game!.fronteerSquareArray[0]
                node.run(sequance)
                node.fillColor = UserDefaults.standard.colorForKey(key: "Queued Square")!
//            node.run(SKAction.scale(by: 0.8, duration: 1.0))
//            node.run(SKAction.scale(to: 1.0, duration: 1.0))
            node.run(SKAction.wait(forDuration: 1.0))
                game!.fronteerSquareArray.remove(at: 0)
        }
        
        if game!.visitedNodeArray.count > 0 && called == false {
            let wait = SKAction.wait(forDuration: 1.0)
            let sequance = SKAction.sequence([wait])
                let node = game!.visitedNodeArray[0]
                node.run(sequance)
                node.fillColor = UserDefaults.standard.colorForKey(key: "Visited Square")!
                game!.visitedNodeArray.remove(at: 0)
        }
        game.update(time: currentTime)
    }
}
