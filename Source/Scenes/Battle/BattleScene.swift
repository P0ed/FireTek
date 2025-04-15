import SpriteKit
import Fx

final class BattleScene: Scene {
	private var engine: Engine!
	private var lastUpdate = 0 as CFTimeInterval

	let hud = HUDNode()

	static func make() -> BattleScene {
		let scene = BattleScene(fileNamed: "BattleScene")!
		scene.scaleMode = .aspectFit
		return scene
	}

	override func didMove(to view: SKView) {
		super.didMove(to: view)

		backgroundColor = SKColor(red: 0.01, green: 0.02, blue: 0.05, alpha: 1)

		let camera = SKCameraNode()
		camera.position = CGPoint(x: 128, y: 128)
		addChild(camera)
		self.camera = camera

		SoundsFactory.preheat()

		let input = InputController(router!.control)
		engine = Engine(scene: self, input: input)
		engine.restart = { [weak self] in self?.router?.startNewGame() }

		camera.addChild(hud)
		hud.zPosition = 2000
		hud.layout(size: size)
	}

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
