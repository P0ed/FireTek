import SpriteKit

class GameScene: SKScene {
	override func didMoveToView(view: SKView) {
		super.didMoveToView(view)
	}

    override func mouseDown(theEvent: NSEvent) {
        let location = theEvent.locationInNode(self)

		let texture = SKTexture(imageNamed: "Tank")
		texture.filteringMode = .Nearest
        let sprite = SKSpriteNode(texture: texture)
        sprite.position = location;
        sprite.setScale(2)

		let action = SKAction.rotateByAngle(CGFloat(M_PI) / 4, duration:1)
		sprite.runAction(SKAction.repeatActionForever(action))

		self.addChild(sprite)
    }

    override func update(currentTime: CFTimeInterval) {

    }
}
