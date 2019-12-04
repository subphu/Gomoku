//  Copyright © 2019 Subph. All rights reserved.
//

import WatchKit
import Foundation
import SpriteKit

class GameInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var spriteKit: WKInterfaceSKScene!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        crownSequencer.delegate = self
        crownSequencer.focus()
        let scene = BoardScene()
        scene.settupBoard(size: 450)
        spriteKit.presentScene(scene)
    }
    
    override func willActivate() {
        super.willActivate()
        crownSequencer.focus()
    }
}

extension GameInterfaceController: WKCrownDelegate {
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
    }
}
