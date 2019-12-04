//  Copyright © 2018 Subph. All rights reserved.
//

// Board start from bottom left
// 0,1 1,1
// 0,0 1,0

import WatchKit
import Foundation
import SpriteKit

let screenBounds = WKInterfaceDevice.current().screenBounds

class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var spriteKit: WKInterfaceSKScene!

    let skSize: CGSize = CGSize(width: screenBounds.size.width, height: screenBounds.size.height - 59)
    let size: CGFloat = 450
    let boxSize: CGFloat = 30
    
    var loading = false
    var scaledSize: CGFloat = 450
    var scaledHalf: CGFloat = 225
    var middle: CGPoint = CGPoint(x: 225, y: 225)
    var scale: CGFloat = 1
    var left: CGFloat = 0
    var bottom: CGFloat = 0
    
    let label: [String] = ["X", "O"]
    var board: Board = Board(size: 15)
    var ai: AI!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        crownSequencer.delegate = self
        crownSequencer.focus()
        ai = AI(board: board)
        draw()
    }
    
    func draw() {
        let scaledScene = SKScene(size: CGSize(width: scaledSize, height: scaledSize))
        scaledHalf = scaledSize / 2
        left = middle.x - scaledHalf
        bottom = middle.y - scaledHalf
        drawAiSpace(scaledScene)
        drawTable(scaledScene)
        drawLabel(scaledScene)
        spriteKit.presentScene(scaledScene)
    }
    
    func drawAiSpace(_ scene: SKScene) {
        for space in board.border {
            let x = CGFloat(space.x) * boxSize - left
            let y = CGFloat(space.y) * boxSize - bottom
            var rect = CGRect()
            rect.origin = CGPoint(x: x, y: y)
            rect.size = CGSize(width: boxSize, height: boxSize)
            let node = SKShapeNode(rect: rect)
            node.fillColor = UIColor(red: 0.2, green: 0.1, blue: 0.1, alpha: 1)
            scene.addChild(node)
        }
    }
    
    func drawTable(_ scene: SKScene) {
        let totalLines = Int(scaledSize / boxSize)
        let startX = boxSize - left.truncatingRemainder(dividingBy: boxSize)
        let startY = boxSize - bottom.truncatingRemainder(dividingBy: boxSize)
        for i in 0...totalLines {
            let idx = CGFloat(i) * boxSize
            let x = startX + idx
            let y = startY + idx
            var verPts = [CGPoint(x: x, y: 0), CGPoint(x: x, y: scaledSize)]
            var horPts = [CGPoint(x: 0, y: y), CGPoint(x: scaledSize, y: y)]
            scene.addChild(SKShapeNode(points: &verPts, count: 2))
            scene.addChild(SKShapeNode(points: &horPts, count: 2))
        }
    }
    
    func drawLabel(_ scene: SKScene) {
        for space in board.used {
            let node = SKLabelNode(text: label[space.stone])
            node.position = getPoint(x: CGFloat(space.x), y: CGFloat(space.y))
            node.position.x -= left
            node.position.y -= bottom
            scene.addChild(node)
        }
    }
    
    func getPoint(x: CGFloat, y: CGFloat) -> CGPoint {
        let constantX: CGFloat = boxSize / 2
        let constantY: CGFloat = 2.5
        return CGPoint(x: x * boxSize + constantX, y: y * boxSize + constantY)
    }
    
    var prevTranslation: CGPoint = CGPoint(x: 0, y: 0)
    @IBAction func pan(_ sender: WKPanGestureRecognizer) {
        let translation = sender.translationInObject()
        switch sender.state.rawValue {
        case 1:
            middle.x += translation.x * -1
            middle.y += translation.y
        default:
            middle.x += (translation.x - prevTranslation.x) * -1
            middle.y += translation.y - prevTranslation.y
        }
        prevTranslation = translation
        checkWall()
        draw()
    }
    
    func checkWall() {
        let maxMid = size - scaledHalf
        middle.x = max(min(middle.x, maxMid), scaledHalf)
        middle.y = max(min(middle.y, maxMid), scaledHalf)
    }
    
    @IBAction func tap(_ sender: WKTapGestureRecognizer) {
        guard !loading else { return }
        let coord = sender.locationInObject()
        var (x, y) = getBoardLocation(from: coord)
        guard board.map[x][y].empty else {
            print(board.placeIn(x, y).score)
            return
            
        }
        print(board.placeIn(x, y).score)
        draw()
        loading = true
        (x, y) = ai.nextMove()
        print(board.placeIn(x, y).score)
        draw()
        loading = false
    }
    
    func getBoardLocation(from loc: CGPoint) -> (Int, Int) {
        let normY = skSize.height - loc.y
        let x = (loc.x / skSize.width * scaledSize + left) / boxSize
        let y = (normY / skSize.height * scaledSize + bottom) / boxSize
        return (Int(x), Int(y))
    }
    
    @IBAction func press(_ sender: Any) {
        board = Board(size: 15)
        draw()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        crownSequencer.focus()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

extension InterfaceController: WKCrownDelegate {
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        scale = min(max(scale + CGFloat(rotationalDelta), 1), 2.99)
        scaledSize = size / scale
        draw()
    }
}
