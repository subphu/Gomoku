//  Copyright © 2019 Subph. All rights reserved.
//

import UIKit
import SpriteKit

class BoardNode: SKNode {
    let player = ["x", "o"]
    
    var size: CGFloat = 450
    var boxSize : CGFloat = 30
    var boardSize: Int = 15
    var board: Board = Board(size: 15)
    var ai: AI?
    var aiTurn: Int = -1
    var locked: Bool = false
    
    func prepare(size: CGFloat, withAI: Bool = false) {
        self.size = size
        boxSize = size / CGFloat(boardSize)
        board = Board(size: boardSize)
        addLines()
    }
    
    func addLines() {
        for i in 0...boardSize {
            let idx = CGFloat(i) * boxSize
            var verPts = [CGPoint(x: idx, y: 0), CGPoint(x: idx, y: size)]
            var horPts = [CGPoint(x: 0, y: idx), CGPoint(x: size, y: idx)]
            addChild(SKShapeNode(points: &verPts, count: 2))
            addChild(SKShapeNode(points: &horPts, count: 2))
        }
    }
    
    func useAI(turn: Int) {
        ai = AI(board: board)
        aiTurn = turn
        guard turn == 0 else { return }
        let position = boardSize / 2
        placeInBoard(position, position)
        addStone(position, position)
    }
    
    func play(in position: CGPoint) {
        guard !locked else { return }
        let x = Int(position.x / boxSize)
        let y = Int(position.y / boxSize)
        
        placeInBoard(x, y)
        addStone(x, y)
        
        guard board.turn % 2 == aiTurn else { return }
        playAI()
    }
    
    func playAI() {
        let queue = DispatchQueue(label: "AI", qos: .userInitiated)
        queue.async { self.runAI() }
    }
    
    private func runAI() {
        guard let ai = ai else { return }
        locked = true
        let (x, y) = ai.nextMove()
        placeInBoard(x, y)
        addStone(x, y)
        locked = false
    }
    
    private func placeInBoard(_ x: Int, _ y: Int) {
        guard 0 <= x && x < board.size else { return }
        guard 0 <= y && y < board.size else { return }
        guard board.map[x][y].empty else { return }
        _ = board.placeIn(x, y)
    }
    
    private func addStone(_ x: Int, _ y: Int) {
        let stoneSize = boxSize * 0.7
        let stone = SKSpriteNode(imageNamed: player[board.turn % 2])
        stone.position.x = CGFloat(x) * boxSize
        stone.position.y = CGFloat(y) * boxSize
        stone.anchorPoint = CGPoint(x: -0.2, y: -0.2)
        stone.size = CGSize(width: stoneSize, height: stoneSize)
        
        addChild(stone)
    }
    
}
