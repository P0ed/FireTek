import SpriteKit
import Fx

final class SpaceScene: Scene {

	private var engine: SpaceEngine!
	private var world: SKNode!
	private var lastUpdate = 0 as CFTimeInterval
	private let hidController = HIDController()

	let hud = HUDNode()

	static func create() -> SpaceScene {
		let scene = SpaceScene(fileNamed: "SpaceScene")!
		scene.scaleMode = .aspectFit
		return scene
	}

	override func didMove(to view: SKView) {
		super.didMove(to: view)

		backgroundColor = SKColor(red: 0.01, green: 0.02, blue: 0.06, alpha: 1)

		let camera = SKCameraNode()
		camera.position = CGPoint(x: 128, y: 128)
		addChild(camera)
		self.camera = camera

		world = SKNode()
		addChild(world)

		SoundsFabric.preheat()

		engine = SpaceEngine(SpaceEngine.Model(
			scene: self,
			inputController: InputController(hidController.eventsController)
		))

		camera.addChild(hud)
		hud.zPosition = 1000
		hud.layout(size: size)
	}

//	func renderTileMap(_ level: PlanetLevel) {
//		let tileSize = 64
//		level.tileMap.forEach { position, tile in
//			let node = SKSpriteNode(color: tile.color, size: CGSize(width: tileSize, height: tileSize))
//			node.position = CGPoint(x: position.x * tileSize, y: position.y * tileSize)
//			node.anchorPoint = .zero
//			world.addChild(node)
//		}
//	}

    override func update(_ currentTime: TimeInterval) {
		if lastUpdate != 0 {
			while currentTime - lastUpdate > SpaceEngine.timeStep {
				lastUpdate += SpaceEngine.timeStep
				engine.simulate()
			}
		} else {
			lastUpdate = currentTime
		}
    }

	override func didFinishUpdate() {
		engine.didFinishUpdate()
	}

	override func keyDown(with event: NSEvent) {}
	override func keyUp(with event: NSEvent) {}
}
