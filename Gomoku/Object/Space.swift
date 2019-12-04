//
//  Space.swift
//  Gomoku
//
//  Created by Subroto Prasetyo Hudiono on 2019/11/27.
//  Copyright © 2019 Subph. All rights reserved.
//

import Foundation

let N = 0, S = 1, E = 2, W = 3
let NW = 4, SE = 5, NE = 6, SW = 7

class Space {
    var name = ""
    var empty = true
    var uncheckedByAI = true
    var x = 0
    var y = 0
    var turn = 0
    var stone = -1
    var enemy = -1
    
    var corner: Space!
    var board: Board!
    var score: [Int] = [0, 0]
    var winScore: [Int] = [0, 0]
    var sides: [Space] = [] // N, S, E, W, NW, SE, NE, SW
    var stoneInLine :[[Int]] = [[1,1,1,1], [1,1,1,1]]   // V, H, \, /
    var endLine:[[Bool]] = [[true,true,true,true,true,true,true,true],
                            [true,true,true,true,true,true,true,true]]
    
    init() {}
    
    func prepare(x:Int, y:Int, board: Board) {
        self.name = String(x) + "," + String(y)
        self.x = x
        self.y = y
        self.board = board
        corner = Space()
        corner.empty = false
        markCorner()
        getSides()
    }
    
    func getSides() {
        sides.append(endLine[0][0] ? board.map[x]  [y+1] : corner)
        sides.append(endLine[0][1] ? board.map[x]  [y-1] : corner)
        sides.append(endLine[0][2] ? board.map[x+1][y]   : corner)
        sides.append(endLine[0][3] ? board.map[x-1][y]   : corner)
        sides.append(endLine[0][4] ? board.map[x-1][y+1] : corner)
        sides.append(endLine[0][5] ? board.map[x+1][y-1] : corner)
        sides.append(endLine[0][6] ? board.map[x+1][y+1] : corner)
        sides.append(endLine[0][7] ? board.map[x-1][y-1] : corner)
    }
    
    func markCorner() {
        let max = board.size - 1
        if (y == max) { endLine[0][0] = false; endLine[1][0] = false
                        endLine[0][4] = false; endLine[1][4] = false
                        endLine[0][6] = false; endLine[1][6] = false }
        if (y == 0)   { endLine[0][1] = false; endLine[1][1] = false
                        endLine[0][5] = false; endLine[1][5] = false
                        endLine[0][7] = false; endLine[1][7] = false }
        if (x == max) { endLine[0][2] = false; endLine[1][2] = false
                        endLine[0][5] = false; endLine[1][5] = false
                        endLine[0][6] = false; endLine[1][6] = false }
        if (x == 0)   { endLine[0][3] = false; endLine[1][3] = false
                        endLine[0][4] = false; endLine[1][4] = false
                        endLine[0][7] = false; endLine[1][7] = false }
    }
    
    func placeAt(currentTurn: Int) {
        turn = currentTurn
        stone = turn % 2
        enemy = (turn+1) % 2
        empty = false
        uncheckedByAI = false
        
        informSides(undo: false)
    }
    
    func clear() {
        informSides(undo: true)
        
        empty = true
        stone = -1
        enemy = -1
        turn = 0
    }
    
    func informSides(undo: Bool) {
        for dir in 0..<8 {
            let line = Int(dir / 2)
            if (sides[dir].stone == enemy) {
                updateLine(dir: dir, line: line, enemy: enemy, status: undo)
            } else {
                let rev = line * 2 + (dir + 1) % 2
                let status = endLine[stone][rev]
                let total = stoneInLine[stone][line]
                updateStone(dir: dir, line: line, player: stone, total: total, status: undo || status, undo: undo)
            }
        }
    }
    
    func updateStone(dir: Int, line: Int, player: Int, total: Int, status: Bool, undo: Bool) {
        if (sides[dir].empty) {
            let rev = line * 2 + (dir + 1) % 2
            sides[dir].endLine[player][rev] = status
            sides[dir].stoneInLine[player][line] += undo ? -total : total
            sides[dir].calculateScore(stone: player)
        } else if (sides[dir].stone == player) {
            sides[dir].updateStone(dir: dir, line: line, player: player, total: total-1, status: status, undo: undo)
        }
    }
    
    func updateLine(dir: Int, line: Int, enemy: Int, status: Bool) {
        if (sides[dir].empty) {
            let rev = line * 2 + (dir + 1) % 2
            sides[dir].endLine[enemy][rev] = status
            sides[dir].calculateScore(stone: enemy)
        } else if (sides[dir].stone == enemy) {
            sides[dir].updateLine(dir: dir, line: line, enemy: enemy, status: status)
        }
    }
    
    func calculateScore(stone: Int) {
        defer {
            let enemy = (stone + 1) % 2
            score[stone] = winScore[stone] + winScore[enemy]/2
            score[enemy] = winScore[enemy] + winScore[stone]/2
        }
        
        let m = max(stoneInLine[stone][0], stoneInLine[stone][1], stoneInLine[stone][2], stoneInLine[stone][3])
        guard m < 5 else { return winScore[stone] = 20000 }
        
        var ctr3 = 0
        var ctr4 = 0
        var value = m + Int.random(in: 0...(m*3))
        
        for (line, totalStone) in stoneInLine[stone].enumerated() {
            let dir = line*2
            if (totalStone == 4) {
                ctr4 += endLine[stone][dir] ? 1 : 0
                ctr4 += endLine[stone][dir+1] ? 1 : 0
            } else if (totalStone == 3) {
                ctr3 += (endLine[stone][dir] && endLine[stone][dir+1]) ? 1 : 0
            }
    
            value += endLine[stone][dir] ? totalStone : 0
            value += endLine[stone][dir+1] ? totalStone : 0
        }
        
        value += (ctr4 > 1) ? 3000 : 0
        value += ((ctr3 + ctr4) > 1) ? 1000 : 0
        
        winScore[stone] = value
    }
    
    func checkWin() -> [Int] {
        var indexes: [Int] = []
        for (i, totalStone) in stoneInLine[stone].enumerated() {
            if totalStone > 4 { indexes.append(i) }
        }
        return indexes
    }
    
    func getAvailableSides() -> [Space] {
        var available: [Space] = []
        sides.forEach { (space) in
            guard space.empty && space.uncheckedByAI else { return }
            space.uncheckedByAI = false
            available.append(space)
        }
        return available
    }
}
