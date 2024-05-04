import SpriteKit
import Fx

final class BattleScene: Scene {

	private var engine: Engine!
	private var lastUpdate = 0 as CFTimeInterval
	private let hid = HIDController()

	let hud = HUDNode()

	static func make() -> BattleScene {
		let scene = BattleScene(fileNamed: "BattleScene")!
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

		SoundsFabric.preheat()

		engine = Engine(.init(
			scene: self,
			inputController: InputController(hid)
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
			while currentTime - lastUpdate > Engine.timeStep {
				lastUpdate += Engine.timeStep
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
