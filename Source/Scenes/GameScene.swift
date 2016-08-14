import SpriteKit
import Fx

final class GameScene: SKScene {

	var engine: Engine!
	var world: SKNode!

	override func didMoveToView(view: SKView) {
		super.didMoveToView(view)

		let camera = SKCameraNode()
		camera.position = CGPoint(x: 128, y: 128)
		addChild(camera)
		self.camera = camera

		world = SKNode()
		addChild(world)

		engine = Engine(Engine.Model(
			scene: unown(self, const))
		)
	}

	func renderTileMap(level: Level) {
		let tileSize = 4
		level.tileMap.forEach { position, tile in
			let node = SKSpriteNode(color: tile.color, size: CGSize(width: tileSize, height: tileSize))
			node.position = CGPoint(x: position.x * tileSize, y: position.y * tileSize)
			node.anchorPoint = CGPointZero
			world.addChild(node)
		}
	}

    override func mouseDown(theEvent: NSEvent) {

		world.removeAllChildren()
		renderTileMap(Level())

//        let location = theEvent.locationInNode(self)
//
//		let texture = SKTexture(imageNamed: "Tank")
//		texture.filteringMode = .Nearest
//        let sprite = SKSpriteNode(texture: texture)
//        sprite.position = location;
//        sprite.setScale(2)
//
//		let action = SKAction.rotateByAngle(CGFloat(M_PI) / 4, duration:1)
//		sprite.runAction(SKAction.repeatActionForever(action))
//
//		self.addChild(sprite)
    }

    override func update(currentTime: CFTimeInterval) {

    }
}
