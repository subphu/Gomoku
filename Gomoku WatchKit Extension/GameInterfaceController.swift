//  Copyright © 2019 Subph. All rights reserved.
//

import WatchKit
import Foundation
import SpriteKit

class GameInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var spriteKit: WKInterfaceSKScene!
    
    var scene: GameScene! = nil
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        crownSequencer.delegate = self
        crownSequencer.focus()
        
        var size = contentFrame.size
        size.height -= contentFrame.origin.y

        scene = GameScene(size: size)
        scene.settupBoard()
        spriteKit.presentScene(scene)
    }
    
    @IBAction func tap(_ sender: WKTapGestureRecognizer) {
        let location = sender.locationInObject()
        var normalized = CGPoint()
        normalized.x = location.x - scene.halfSize.width
        normalized.y = scene.halfSize.height - location.y
        scene.tap(in: normalized)
    }
    
    @IBAction func press(_ sender: Any) {
    }
    
    var prevTranslation: CGPoint = CGPoint(x: 0, y: 0)
    @IBAction func pan(_ sender: WKPanGestureRecognizer) {
        guard sender.state != .ended else { return }
        let translation = sender.translationInObject()
        let normalized = CGPoint(x: translation.x, y: -translation.y)
        var delta = normalized
        if sender.state == .changed {
            delta.x = normalized.x - prevTranslation.x
            delta.y = normalized.y - prevTranslation.y
        }
        scene.move(translation: delta)
        prevTranslation = normalized
    }
    
    override func willActivate() {
        super.willActivate()
        crownSequencer.focus()
    }
}

extension GameInterfaceController: WKCrownDelegate {
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        scene.zoom(by: CGFloat(1 + rotationalDelta))
    }
}
