//
//  GameManager.swift
//  Snake
//
//  Created by Álvaro Santillan on 1/8/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//  Bug Seg-fault when reach gameboard end.

//--------------------
// Create tuple data structure.
struct Tuple {
    var x: Int
    var y: Int
}

// Make the tuple hashable.
extension Tuple: Hashable {
    public var hashValue: Int {
        return x.hashValue ^ y.hashValue
    }
}
    
    
// Takes a two dimentional matrix, determins the legal squares.
// The results are converted into a nested dictionary.
func gameBoardMatrixToDictionary(gameBoardMatrix: Array<Array<Int>>) -> Dictionary<Tuple, Dictionary<Tuple, Float>> {
    // Initialize the two required dictionaries.
    var mazeDictionary = [Tuple : [Tuple : Float]]()
    var vaildMoves = [Tuple : Float]()

    // Loop through every cell in the maze.
    for(y, matrixRow) in gameBoardMatrix.enumerated() {
        for(x, _) in matrixRow.enumerated() {
            // If in a square that is leagal, append valid moves to a dictionary.
            if (gameBoardMatrix[y][x] == 0 || gameBoardMatrix[y][x] == 2) {
                let isYNegIndex = gameBoardMatrix.indices.contains(y-1)
                let isYIndex = gameBoardMatrix.indices.contains(y+1)
//                let isXNegIndex = gameBoardMatrix.indices.contains(x-1)
                let isXIndex = gameBoardMatrix.indices.contains(x+1)
//                let isY = gameBoardMatrix.indices.contains(y)
                
                
//                if isYIndexValid && isYNegIndexValid && isXNegIndexValid && isXIndexValid {
                    // Up
//                    if y-1 != -1 {
                    if isYNegIndex {
                        if (gameBoardMatrix[y-1][x] == 0 || gameBoardMatrix[y-1][x] == 2) {
                            vaildMoves[Tuple(x: x, y: y-1)] = 1
                        }
                    }
                    // Right
                    if isXIndex {
                        if (gameBoardMatrix[y][x+1] == 0 || gameBoardMatrix[y][x+1] == 2) {
                            // Floats so that we can have duplicates keys in dictinaries (Swift dictionary workaround).
                            vaildMoves[Tuple(x: x+1, y: y)] = 1.000001
                        }
                    }
                    // Left
//                    if isXNegIndex {
                    if x-1 != -1 {
                        if (gameBoardMatrix[y][x-1] == 0 || gameBoardMatrix[y][x-1] == 2) {
                            vaildMoves[Tuple(x: x-1, y: y)] = 1.000002
                        }
                    }
                    // Down
                    if isYIndex {
                        if (gameBoardMatrix[y+1][x] == 0 || gameBoardMatrix[y+1][x] == 2) {
                            vaildMoves[Tuple(x: x, y: y+1)] = 1.000003
                            }
                        }
                // Append the valid move dictionary to a master dictionary to create a dictionary of dictionaries.
                mazeDictionary[Tuple(x: x, y: y)] = vaildMoves
                // Reset the inner dictionary templet.
                vaildMoves = [Tuple : Float]()
//                }
            }
        }
    }
    print("mazetoDictionary Returned")
    return mazeDictionary
}

// Genarate a path and optional statistics from the results of BFS.
func formatSearchResults(squareAndParentSquare: [Tuple : Tuple], gameBoard: [Tuple : Dictionary<Tuple, Float>], currentSquare: Tuple, visitedSquareCount: Int, returnPathCost: Bool, returnSquaresVisited: Bool) -> ([Int], Int, Int) {
    var squareAndParentSquareTuplePath = [Tuple : Tuple]()
    var squareAndNoParentArrayPath = [(Int, Int)]()
    // 1 == left, 2 == up, 3 == right, 4 == down
    var movePath = [Int]()

    // Find a path using the results of the search algorthim.
    func findPath(squareAndParentSquare: [Tuple : Tuple], currentSquare: Tuple) -> ([Int],[(Int, Int)],[Tuple : Tuple]) {
        if (currentSquare == Tuple(x:-1, y:-1)) {
            return (movePath, squareAndNoParentArrayPath, squareAndParentSquareTuplePath)
        } else {
            squareAndParentSquareTuplePath[currentSquare] = squareAndParentSquare[currentSquare]
            squareAndNoParentArrayPath.append((currentSquare.x,currentSquare.y))
            let xValue = currentSquare.x - squareAndParentSquare[currentSquare]!.x
            let yValue = currentSquare.y - squareAndParentSquare[currentSquare]!.y
            // 1 == left, 2 == up, 3 == right, 4 == down
            if (xValue == 0 && yValue == 1) {
                movePath.append(2)
            // 1 == left, 2 == up, 3 == right, 4 == down
            } else if (xValue == 0 && yValue == -1) {
                movePath.append(4)
            // 1 == left, 2 == up, 3 == right, 4 == down
            } else if (xValue == 1 && yValue == 0) {
                movePath.append(1)
            // 1 == left, 2 == up, 3 == right, 4 == down
            } else if (xValue == -1 && yValue == 0) {
                movePath.append(3)
            }
            
            findPath(squareAndParentSquare: squareAndParentSquare, currentSquare: squareAndParentSquare[currentSquare]!)
        }
//        print("findPath Returned")
        return (movePath, squareAndNoParentArrayPath, squareAndParentSquareTuplePath)
    }

    // Calculate the path cost of the path returned by the "findPath" function.
    func findPathCost(solutionPathDuple: [Tuple : Tuple], gameBoard: [Tuple : Dictionary<Tuple, Float>]) -> Int {
        var cost = 0
        
        for square in solutionPathDuple.keys {
            cost += Int(gameBoard[square]![solutionPathDuple[square]!] ?? 0)
        }
        print("findPathCost Returned")
        return(cost)
    }
    let (solutionPathMoves, solutionPathArray, solutionPathDuple) = findPath(squareAndParentSquare: squareAndParentSquare, currentSquare: currentSquare)
    
    // Prepare and present the result returns.
    if (returnPathCost == true) {
        // Use the "path" method result to calculate a pathcost using the "pathcost" method.
        let solutionPathCost = findPathCost(solutionPathDuple: solutionPathDuple, gameBoard: gameBoard)
        
        if (returnSquaresVisited == true) {
            return (solutionPathMoves, solutionPathCost, visitedSquareCount)
        } else {
            return (solutionPathMoves, solutionPathCost, 0)
        }
    }
    else if (returnPathCost == false) && (returnSquaresVisited == true) {
        return (solutionPathMoves, 0, visitedSquareCount)
    }
    else {
        print("solutionPathMoves, 0, 0")
        return (solutionPathMoves, 0, 0)
    }
}

// Steps in Breath First Search
// Mark parent
// Mark current node as visited.
// Append children nodes if needed to the fronter.
// Select one by one a unvisited child node to explore.
// Do this for all the child nodes
// Repeat untill the goal is visited.

// BFS produces a dictionary in which each valid square points too only one parent.
// Then the dictionary is processed to create a valid path.
// The nodes are traversed in order found in the dictionary parameter.
func breathFirstSearch(startSquare: Tuple, goalSquare: Tuple, gameBoard: [Tuple : Dictionary<Tuple, Float>], returnPathCost: Bool, returnSquaresVisited: Bool) -> ([Int], Int, Int) {
    // Initalize variable and add first square manually.
    print("BFS Entered")
    var visitedSquares = [Tuple]()
    var fronterSquares = [startSquare]
    var currentSquare = startSquare
    var visitedSquareCount = 1
    var counter = 0
    // Dictionary used to find a path, every square will have only one parent.
    var squareAndParentSquare = [startSquare : Tuple(x:-1, y:-1)]
    
    // Break once the goal is reached (the goals parent is noted a cycle before when it was a new node.)
    while (currentSquare != goalSquare) {
        counter += 1
//        print("BFS while loop entered.", counter)
//        print("visitedSquareCount", visitedSquareCount)
        // Mark current node as visited. (If statement required due to first node.)
        print("current square", currentSquare)
        if !(visitedSquares.contains(currentSquare)) {
            print("if hit")
            visitedSquares += [currentSquare]
            
            visitedSquareCount += 1
        }
        
        // Repeat through all the nodes in the sub dictionary.
        // Append to fronter and mark parent.
        for (newFronterSquare, _) in gameBoard[currentSquare]! {
            print("for hit")
            if !(visitedSquares.contains(newFronterSquare)) {
                print("if 2 hit")
                fronterSquares += [newFronterSquare]
                squareAndParentSquare[newFronterSquare] = currentSquare
            }
        }
        // New currentNode is first in queue (BFS).
        currentSquare = fronterSquares[0]
        fronterSquares.remove(at: 0)
    }
    // Genarate a path and optional statistics from the results of BFS.
    print("BFS Completed")
    return(formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: gameBoard, currentSquare: goalSquare, visitedSquareCount: visitedSquareCount, returnPathCost: returnPathCost, returnSquaresVisited: returnSquaresVisited))
}

// Steps in Depth First Search
// Mark parent
// Mark current node as visited.
// Append children nodes if needed to the fronter.
// Select the last unvisited child node to explore.
// Repeat untill the goal is visited.

// DFS produces a dictionary in which each valid square points too only one parent.
// Then the dictionary is processed to create a valid path.
// The nodes are traversed in order found in the dictionary parameter.
func depthFirstSearch(startSquare: Tuple, goalSquare: Tuple, gameBoard: [Tuple : Dictionary<Tuple, Float>], returnPathCost: Bool, returnSquaresVisited: Bool) -> ([Int], Int, Int) {
    // Initalize variable and add first square manually.
    var visitedSquares = [Tuple]()
    var fronterSquares = [startSquare]
    var currentSquare = startSquare
    var visitedSquareCount = 1
    // Dictionary used to find a path, every square will have only one parent.
    var squareAndParentSquare = [startSquare : Tuple(x:-1, y:-1)]
    
    // Break once the goal is reached (the goals parent is noted a cycle before when it was a new node.)
    while (currentSquare != goalSquare) {
        // Mark current node as visited. (If statement required due to first node.)
        if !(visitedSquares.contains(currentSquare)) {
            visitedSquares += [currentSquare]
            visitedSquareCount += 1
        }
        
        // Repeat through all the nodes in the sub dictionary.
        // Append to fronter and mark parent.
        for (newFronterSquare, _) in gameBoard[currentSquare]! {
            if !(visitedSquares.contains(newFronterSquare)) {
                fronterSquares += [newFronterSquare]
                squareAndParentSquare[newFronterSquare] = currentSquare
            }
        }
        currentSquare = fronterSquares.last!
        fronterSquares.popLast()
    }
    // Genarate a path and optional statistics from the results of DFS.
    return(formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: gameBoard, currentSquare: goalSquare, visitedSquareCount: visitedSquareCount, returnPathCost: returnPathCost, returnSquaresVisited: returnSquaresVisited))
}
////--------

import SpriteKit

class GameManager {
    var viewController: GameScreenViewController!
    var play = true
    
    var gameStarted = false
    var matrix = [[Int]]()
    var test = [Int]()
    var onPathMode = false
    var scene: GameScene!
    var nextTime: Double?
    var gameSpeed: Double = 1
    var playerDirection: Int = 1 // 1 == left, 2 == up, 3 == right, 4 == down
    var currentScore: Int = 0
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    // Understood - Initiate the starting position of the snake.
    func initiateSnakeStartingPosition() {
        scene.snakeBodyPos.append((3, 3))
//        scene.snakeHeadPos = [scene.snakeBodyPos[0]]
        matrix[3][3] = 2
        scene.snakeBodyPos.append((3, 4))
        matrix[3][4] = 1
        scene.snakeBodyPos.append((3, 5))
        matrix[3][5] = 1
        scene.snakeBodyPos.append((3, 6))
        matrix[3][5] = 1
        scene.snakeBodyPos.append((3, 7))
        matrix[3][5] = 1
        scene.snakeBodyPos.append((3, 8))
        matrix[3][5] = 1

        spawnFoodBlock()
        gameStarted = true
    }
    
    // Understood - Spawn a new food block into the game.
    var prevX = 0
    var prevY = 0
    
    func spawnFoodBlock() {
        algoirthChoice()
//        print("spawning food")
        let randomX = CGFloat(arc4random_uniform(15)) //73
        let randomY = CGFloat(arc4random_uniform(15)) //41
        matrix[Int(randomY)][Int(randomX)] = 2
        matrix[prevX][prevY] = 0
        let snakeHead = scene.snakeBodyPos[0]
//        print("official head",snakeHead)
//        print("head x", snakeHead.1, "head y", snakeHead.0)
//        print("food", Int(randomX), "-", Int(randomY))
//        for i in 0...14 {
//            print(matrix[i])
//        }
        let path = depthFirstSearch(startSquare: Tuple(x:Int(randomX), y:Int(randomY)), goalSquare: Tuple(x:snakeHead.1, y:snakeHead.0), gameBoard: gameBoardMatrixToDictionary(gameBoardMatrix: matrix), returnPathCost: false, returnSquaresVisited: false)
//        print("path", path.0)
        test = path.0
        // 1 == left, 2 == up, 3 == right, 4 == down
        prevX = Int(randomY)
        prevY = Int(randomX)
        
//        for i in 0...14 {
//            print(matrix[i])
//        }
        scene.foodPosition = CGPoint(x: randomX, y: randomY)
    }
    
    func bringOvermatrix(tempMatrix: [[Int]]) {
        matrix = tempMatrix
    }
    
    func runPredeterminedPath() {
        if gameStarted == true {
            if (test.count != 0) {
//                print("-----sdfg", test.count, test[0])
                swipe(ID: test[0])
                test.remove(at: 0)
                onPathMode = true
            } else {
                onPathMode = false
            }
        }
    }
    
    func update(time: Double) {
//        print("play or pause", play)
        if nextTime == nil {
            nextTime = time + gameSpeed
        } else {
            if time >= nextTime! {
                nextTime = time + gameSpeed
//                print(matrix)
                runPredeterminedPath()
                updateSnakePosition()
                checkIfPaused()
                checkForFoodCollision()
                checkForDeath()
            }
        }
    }
    
    func checkIfPaused() {
        if scene.playOrPause == false {
            print("the game is now paused")
            gameSpeed = 10
            
        } else {
            print("the game is unpaused")
            gameSpeed = 0.3
        }
    }
    
    func endTheGame() {
        updateScore()
        scene.foodPosition = nil
        scene.snakeBodyPos.removeAll()

        // Ending Animation
//        scene.gameBackground.run(SKAction.scale(to: 0, duration: 0.4)) {
//            self.scene.gameBackground.isHidden = true
//            self.scene.gameLogo.isHidden = false
//            self.scene.gameLogo.run(SKAction.move(to: CGPoint(x: 0, y: (self.scene.frame.size.height / 2) - 200), duration: 0.5)) {
//                 self.scene.gameScore.isHidden = true
//                 self.scene.playButton.isHidden = false
//                 self.scene.playButton.run(SKAction.scale(to: 1, duration: 0.3))
//                 self.scene.highScore.run(SKAction.move(to: CGPoint(x: 0, y: self.scene.gameLogo.position.y - 50), duration: 0.3))
//               }
//          }

    }
    
    // this is run when game hasent started. fix for optimization.
    func checkForDeath() {
//        print("checked---------")
        if scene.snakeBodyPos.count > 0 {
            // Create temp variable of snake without the head.
            var snakeBody = scene.snakeBodyPos
            snakeBody.remove(at: 0)
            // If head is in same position as the body the snake is dead.
            // The snake dies in corners becouse blocks are stacked.
            if contains(a: snakeBody, v: scene.snakeBodyPos[0]) {
                endTheGame()
            }
        }
    }
    
    func checkForFoodCollision() {
        if scene.foodPosition != nil {
            let x = scene.snakeBodyPos[0].0
            let y = scene.snakeBodyPos[0].1
            if Int((scene.foodPosition?.x)!) == y && Int((scene.foodPosition?.y)!) == x {
                spawnFoodBlock()
                // Update the score
                currentScore += 1
                scene.gameScore.text = "Score: \(currentScore)"
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if let vc = appDelegate.window?.rootViewController {
                    self.viewController = vc as! GameScreenViewController
                    self.viewController?.scoreButton.setTitle(String(currentScore), for: .normal)
                }
                // Grow snake by 3 blocks.
                scene.snakeBodyPos.append(scene.snakeBodyPos.last!)
                scene.snakeBodyPos.append(scene.snakeBodyPos.last!)
                scene.snakeBodyPos.append(scene.snakeBodyPos.last!)
             }
         }
    }
    
    func swipe(ID: Int) {
//        if !(ID == 2 && playerDirection == 4) && !(ID == 4 && playerDirection == 2) {
//            if !(ID == 1 && playerDirection == 3) && !(ID == 3 && playerDirection == 1) {
                playerDirection = ID
//            }
//        }
    }
    
    private func updateSnakePosition() {
        //4
        var xChange = -1
        var yChange = 0
        //5
        switch playerDirection {
            case 1:
                //left
                xChange = -1
                yChange = 0
                break
            case 2:
                //up
                xChange = 0
                yChange = -1
                break
            case 3:
                //right
                xChange = 1
                yChange = 0
                break
            case 4:
                //down
                xChange = 0
                yChange = 1
                break
            default:
                break
        }
        //6
        if scene.snakeBodyPos.count > 0 {
            var start = scene.snakeBodyPos.count - 1
            matrix[scene.snakeBodyPos[start].0][scene.snakeBodyPos[start].1] = 0
            while start > 0 {
                scene.snakeBodyPos[start] = scene.snakeBodyPos[start - 1]
                start -= 1
            }
            scene.snakeBodyPos[0] = (scene.snakeBodyPos[0].0 + yChange, scene.snakeBodyPos[0].1 + xChange)
            matrix[scene.snakeBodyPos[0].0][scene.snakeBodyPos[0].1] = 1
            matrix[scene.snakeBodyPos[1].0][scene.snakeBodyPos[1].1] = 1
            matrix[scene.snakeBodyPos[2].0][scene.snakeBodyPos[2].1] = 1
//            for i in 0...14 {
//                print(matrix[i])
//            }
//            print("----")
        }
        
        if scene.snakeBodyPos.count > 0 {
            let x = scene.snakeBodyPos[0].1
            let y = scene.snakeBodyPos[0].0
            if y > 15 {
                scene.snakeBodyPos[0].0 = 0
            } else if y < 0 {
                scene.snakeBodyPos[0].0 = 15
            } else if x > 15 {
               scene.snakeBodyPos[0].1 = 0
            } else if x < 0 {
                scene.snakeBodyPos[0].1 = 15
            }
        }
        //7
        colorGameNodes()
    }
    
    func colorGameNodes() {
        for (node, x, y) in scene.gameBoard {

            if contains(a: scene.snakeBodyPos, v: (x,y)) {
                if (onPathMode == false) {
                    node.fillColor = SKColor.white
                }
            }
            if contains(a: scene.snakeBodyPos, v: (x,y)) {
                if (onPathMode == true) {
                    node.fillColor = SKColor.green
                    if contains(a: [scene.snakeBodyPos.first!], v: (x,y)) {
                        node.fillColor = SKColor.red
                    }
                }
            }
            else {
                node.fillColor = SKColor.clear
                if scene.foodPosition != nil {
                    if Int((scene.foodPosition?.x)!) == y && Int((scene.foodPosition?.y)!) == x {
                        node.fillColor = SKColor.white
                    }
                }
            }
        }
    }
    
    func contains(a:[(Int, Int)], v:(Int,Int)) -> Bool {
        let (c1, c2) = v
        for (v1, v2) in a { if v1 == c1 && v2 == c2 { return true } }
        return false
    }
    
    func algoirthChoice() {
        if scene.algoithimChoice == 0 {
            print("DFS")
            
        }
        if scene.algoithimChoice == 1 {
            print("BFS")
            
        }
    }

    func updateScore() {
        // Update the high score if need be.
         if currentScore > UserDefaults.standard.integer(forKey: "highScore") {
              UserDefaults.standard.set(currentScore, forKey: "highScore")
         }
        
        // Reset and present score variables on game menu.
         currentScore = 0
         scene.highScore.text = "High Score: \(UserDefaults.standard.integer(forKey: "highScore"))"
    }
}