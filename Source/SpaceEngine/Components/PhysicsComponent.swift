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
	var rawValue: UInt8

	static var zero: Category { .init(rawValue: 0) }

	static var blu: Category { .init(rawValue: 1 << 0) }
	static var red: Category { .init(rawValue: 1 << 1) }

	static var ship: Category { .init(rawValue: 1 << 2) }
	static var projectile: Category { .init(rawValue: 1 << 3) }
	static var crystal: Category { .init(rawValue: 1 << 4) }
}

extension Category {
	var team: Team? { contains(.blu) ? .blu : contains(.red) ? .red : .none }
}

extension Team {
	var opposite: Team { self == .blu ? .red : .blu }
	var category: Category { self == .blu ? .blu : .red }
}
