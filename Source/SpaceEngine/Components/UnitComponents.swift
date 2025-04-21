import Fx
import SpriteKit

struct ShipRef {
	let physics: ComponentIdx<PhysicsComponent>
	let input: ComponentIdx<Input>
	let ship: ComponentIdx<Ship>
	var info: String
}

struct Ship {
	var hp: HP
	var engine: ShipEngine
	var reactor: Capacitor
	var shield: Capacitor
	var primary: Weapon
	var secondary: Weapon
}

struct HP {
	var maxArmor: UInt16
	var maxStructure: UInt16

	var front: UInt16
	var side: UInt16
	var core: UInt16
	var damaged: Damaged = []

	init(armor: UInt16, structure: UInt16) {
		maxArmor = armor
		maxStructure = structure
		front = armor
		side = armor
		core = structure
	}
}

struct ShipEngine {
	var impulse: UInt16
	var warp: UInt16
	var efficiency: UInt16
	var driving: UInt16 = 0
}

struct Capacitor {
	var value: UInt16
	var maxValue: UInt16
	var recharge: UInt16

	init(value: UInt16, recharge: UInt16 = 0) {
		self.value = value
		self.maxValue = value
		self.recharge = recharge
	}

	var normalized: CGFloat { CGFloat(value) / CGFloat(maxValue) }

	var isCharged: Bool { value == maxValue }

	mutating func charge() {
		value = min(maxValue, value + recharge)
	}
	mutating func charge(from capacitor: inout Capacitor) {
		if !isCharged, capacitor.drain(recharge) { charge() }
	}
	mutating func drain(_ amount: UInt16) -> Bool {
		if value >= amount {
			value -= amount
			return true
		}
		return false
	}
	mutating func discharge() { value = 0 }
}

struct TargetComponent {
	var target: Entity?
}

enum Team {
	case blu
	case red
}

enum Crystal {
	case blue, red, purple, cyan, yellow, green, orange
}

struct LootComponent {
	let crystal: Crystal
	let count: Int8
}

struct DeadComponent {
	let killedBy: Entity
}

struct Weapon {
	var type: WeaponType
	var damage: UInt16
	var velocity: UInt16
	var capacitor: Capacitor
}

struct ProjectileComponent {
	var source: Entity
	var target: Entity?
	var type: WeaponType
	var damage: UInt16
}

struct LifetimeComponent {
	var lifetime: UInt16
}

struct Damaged: OptionSet {
	var rawValue: UInt8

	static var wrp: Damaged { .init(rawValue: 1 << 1) }
	static var imp: Damaged { .init(rawValue: 1 << 2) }
	static var shl: Damaged { .init(rawValue: 1 << 3) }
	static var cap: Damaged { .init(rawValue: 1 << 4) }
	static var prm: Damaged { .init(rawValue: 1 << 5) }
	static var sec: Damaged { .init(rawValue: 1 << 6) }
}
