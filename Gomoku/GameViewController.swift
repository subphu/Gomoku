//  Copyright © 2019 Subph. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    @IBOutlet weak var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = BoardScene(size: skView.bounds.size)
        scene.settupBoard()
        scene.scaleMode = .resizeFill
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
    }

}
