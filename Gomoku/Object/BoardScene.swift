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
    }
}
