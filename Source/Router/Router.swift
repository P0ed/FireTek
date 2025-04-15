import SpriteKit

protocol Routable: AnyObject {
	var router: Router? { get set }
	var rootScene: SKScene { get }
}

class Scene: SKScene, Routable {
	weak var router: Router?
	var rootScene: SKScene { self }
}

final class Router {
	let view: SKView
	let control: HIDController
	private(set) var stack: [Routable] = []

	init(view: SKView) {
		self.view = view
		control = HIDController()
	}

	func push(_ routable: Routable) {
		stack.append(routable)
		routable.router = self

		view.presentScene(routable.rootScene)
	}

	func pop() {
		guard !stack.isEmpty else { return }

		let routable = stack.removeLast()
		routable.router = nil

		view.presentScene(stack.last?.rootScene)
	}
}

extension Router {

	func startNewGame() {
		if !stack.isEmpty { pop() }
		push(BattleScene.make())
	}
}
