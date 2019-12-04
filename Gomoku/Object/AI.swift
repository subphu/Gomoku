//  Copyright © 2019 Subph. All rights reserved.
//

import Foundation

class AI {
    var board: Board!
    
    init(board: Board) {
        self.board = board
    }
    
    func randomMove() -> Space {
        return board.border.randomElement()!
    }
    
    func nextMove() -> (Int, Int) {
        let player = board.turn % 2
        var move: Space = board.border.max{ $0.score[player] < $1.score[player] }!

        guard move.score[player] < 1000 else { return (move.x, move.y) }
        
        var max = -90000
        var value = 0
        for space in board.border {
            value = searchValue(depth: 2,
                                pruneValue: max,
                                candidate: space)
            if value > max {
                max = value
                move = space
            }
        }
        return (move.x, move.y)
    }

    func searchValue(depth: Int, pruneValue: Int, candidate: Space) -> Int {
        guard depth > 0 else { return candidate.winScore[board.turn % 2] }
        
        let nextDepth = depth - 1
        var max = -90000
        var local = 0
        
        _ = board.placeIn(candidate.x, candidate.y)
        
        for space in board.border {
            local = searchValue(depth: nextDepth, pruneValue: -max, candidate: space)
            
            if local > max {
                max = local
                if local >= pruneValue {
                    board.undo()
                    return -max
                }
            }
        }
        
        board.undo()
        return -max
    }
}
