import SpriteKit

struct PhysicsComponent {
	var node: SKNode
	var position: CGPoint
	var momentum: CGVector = .zero
	var rotation: CGFloat = 0
	var category: Category = .zero
	var contacts: Category = .zero
	var size: CGFloat = 1
}

struct Category: OptionSet {
	var rawValue: UInt16

	static var zero: Category { .init(rawValue: 0) }

	static var blueShip: Category { .init(rawValue: 1 << 0) }
	static var redShip: Category { .init(rawValue: 1 << 1) }

	static var projectile: Category { .init(rawValue: 1 << 2) }
	static var crystal: Category { .init(rawValue: 1 << 3) }

	static var ships: Category { [.blueShip, .redShip] }
}
