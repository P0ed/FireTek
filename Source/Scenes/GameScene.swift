import SpriteKit
import Fx

final class GameScene: SKScene {

	private var engine: Engine!
	private var world: SKNode!
	private var lastUpdate = 0 as CFTimeInterval

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

		renderTileMap(Level())
	}

	func renderTileMap(level: Level) {
		let tileSize = 32
		level.tileMap.forEach { position, tile in
			let node = SKSpriteNode(color: tile.color, size: CGSize(width: tileSize, height: tileSize))
			node.position = CGPoint(x: position.x * tileSize, y: position.y * tileSize)
			node.anchorPoint = CGPointZero
			world.addChild(node)
		}
	}

    override func update(currentTime: CFTimeInterval) {
		if lastUpdate != 0 {
			while currentTime - lastUpdate > Engine.timeStep {
				lastUpdate += Engine.timeStep
				engine.simulate()
			}
		} else {
			lastUpdate = currentTime
		}
    }
}