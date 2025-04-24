import SpriteKit
import Fx

final class SpaceScene: Scene {
	private var engine: Engine!
	private var lastUpdate = 0 as CFTimeInterval

	let hud = HUDNode()

	static func make() -> SpaceScene {
		let scene = SpaceScene(size: CGSize(width: 1024, height: 768))
		scene.scaleMode = .aspectFit
		scene.backgroundColor = .black

		_ = Sound.sounds

		return scene
	}

	override func didMove(to view: SKView) {
		super.didMove(to: view)

		let camera = SKCameraNode()
		addChild(camera)
		self.camera = camera

		let input = InputController(router!.control)
		engine = Engine(scene: self, input: input)
		engine.restart = { [weak self] in self?.router?.startNewGame() }

		camera.addChild(hud)
		hud.zPosition = 2000
		hud.layout(size: size)
	}

    override func update(_ currentTime: TimeInterval) {
		if lastUpdate != 0 {
			while currentTime - lastUpdate > .timeStep {
				lastUpdate += .timeStep
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
