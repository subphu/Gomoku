//
//  Board.swift
//  Gomoku
//
//  Created by Subroto Prasetyo Hudiono on 2019/11/27.
//  Copyright © 2019 Subph. All rights reserved.
//

import Foundation
import SpriteKit

class Board {
    let size: Int!
    
    var turn = 0
    var map: [[Space]] = [[]]
    var used: [Space] = []
    var border: [Space] = []
    var newBorder: [Int] = []
    var removedIdx: [Int] = []
    
    init(size: Int) {
        self.size = size
        reset()
    }
    
    func reset() {
        turn = 0
        used = []
        border = []
        newBorder = []
        removedIdx = []
        map = (0..<size).map { _ in
              (0..<size).map { _ in Space() } }
        for x in 0..<size {
            for y in 0..<size {
                map[x][y].prepare(x: x, y: y, board: self)
            }
        }
    }
    
    func addBorder(from space: Space) {
        let sides = space.getAvailableSides()
        newBorder.append(sides.count)
        border.append(contentsOf: sides)
        guard let idx = (border.firstIndex{ $0 === space }) else { return }
        border.remove(at: idx)
        removedIdx.append(idx)
    }
    
    func removeBorder(from space: Space) {
        for _ in 0..<newBorder.removeLast() {
            border.last?.uncheckedByAI = true
            border.removeLast()
        }
        border.insert(space, at: removedIdx.removeLast())
    }
    
    func placeIn(_ x: Int, _ y: Int) -> Space {
        let space = map[x][y]
        guard space.empty else { return space }
//        print("Place", space.x, space.y, space.score)
        
        space.placeAt(currentTurn: turn)
        addBorder(from: space)
        used.append(space)
        turn += 1
        
//        print("Border", border.count, newBorder.last!, removedIdx.last ?? "-")
//        print("Win", space.checkWin())
        return space
    }
    
    func undo() {
        let space = used.removeLast()
        removeBorder(from: space)
        space.clear()
        turn -= 1
//        print("Undo", space.x, space.y, space.score)
//        print("Border", border.count, newBorder.last!, removedIdx.last ?? "-")
    }
    
}
