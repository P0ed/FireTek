import SpriteKit

struct PhysicsComponent {
	var node: SKNode
	var position: CGPoint
	var momentum: CGVector = .zero
	var rotation: Angle = .zero
	var category: Category
	var size: CGFloat = 1
}

struct Category: OptionSet {
	var rawValue: UInt32

	static var zero: Category { .init(rawValue: 0) }
	static var blueShips: Category { .init(rawValue: 1 << 0) }
	static var redShips: Category { .init(rawValue: 1 << 1) }
	static var projectile: Category { .init(rawValue: 1 << 2) }
	static var crystal: Category { .init(rawValue: 1 << 3) }
}
