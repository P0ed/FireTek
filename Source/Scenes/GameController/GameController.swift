import SpriteKit

final class GameController: Routable {
	weak var router: Router?
	let rootScene: SKScene

	private var state: GameState

	init(state: GameState) {
		self.state = state
//		rootScene = SpaceScene.create()
		rootScene = MainMenuScene(size: CGSize(width: 640, height: 400))
	}
}
