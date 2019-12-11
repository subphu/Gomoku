//  Copyright © 2019 Subph. All rights reserved.
//

import UIKit
import SpriteKit

class BoardNode: SKNode {
    let player = ["x", "o"]
    
    var size: CGFloat = 450
    var boxSize : CGFloat = 30
    var board: Board = Board(size: 15)
    
    func prepare(size: CGFloat) {
        self.size = size
        let boardSize = Int(size / boxSize)
        boxSize = size / CGFloat(boardSize)
        board = Board(size: boardSize)
    }
}
