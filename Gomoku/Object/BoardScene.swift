//  Copyright © 2019 Subph. All rights reserved.
//

import SpriteKit

class BoardScene: SKScene {
    let player = [SKSpriteNode(imageNamed: "x"), SKSpriteNode(imageNamed: "o")]
    
    let boxSize : CGFloat = 30
    var fullSize: CGFloat = 450
    var scaledSize: CGFloat = 450
    var scaledHalf: CGFloat = 225
    var middle: CGPoint = CGPoint(x: 225, y: 225)
    
    var scale: CGFloat = 1
    var left: CGFloat = 0
    var bottom: CGFloat = 0
    
    var board: Board = Board(size: 15)
    
    func settupBoard() {
        fullSize = max(size.width, size.height)
        scaledSize = fullSize
        scaledHalf = scaledSize / 2
        middle = CGPoint(x: scaledHalf, y: scaledHalf)
        board = Board(size: Int(fullSize / boxSize))
        drawLines()
    }
    
    func drawLines() {
        let totalLines = Int(scaledSize / boxSize)
        let startX = boxSize - left.truncatingRemainder(dividingBy: boxSize)
        let startY = boxSize - bottom.truncatingRemainder(dividingBy: boxSize)
        for i in 0...totalLines {
            let idx = CGFloat(i) * boxSize
            let x = startX + idx
            let y = startY + idx
            var verPts = [CGPoint(x: x, y: 0), CGPoint(x: x, y: scaledSize)]
            var horPts = [CGPoint(x: 0, y: y), CGPoint(x: scaledSize, y: y)]
            addChild(SKShapeNode(points: &verPts, count: 2))
            addChild(SKShapeNode(points: &horPts, count: 2))
        }
    }

}
