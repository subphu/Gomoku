//  Copyright © 2019 Subph. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    @IBOutlet weak var skView: SKView!
    
    var scene: GameScene! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scene = GameScene(size: skView.bounds.size)
        scene.settupBoard()
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
    }

}
