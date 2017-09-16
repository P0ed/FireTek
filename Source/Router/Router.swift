import SpriteKit

protocol Routable: class {
	weak var router: Router? { get set }
}

final class Router {
	let view: SKView
	private(set) var stack: [SKScene & Routable] = []

	init(view: SKView) {
		self.view = view
	}

	func push(_ routable: SKScene & Routable) {
		stack.append(routable)
		routable.router = self

		view.presentScene(routable)
	}

	func pop() {
		guard !stack.isEmpty else { return }

		let routable = stack.removeLast()
		routable.router = nil

		view.presentScene(stack.last?.scene)
	}
}
