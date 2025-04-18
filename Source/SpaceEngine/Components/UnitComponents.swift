import Fx
import SpriteKit

struct ShipComponent {
	let sprite: ComponentIdx<SpriteComponent>
	let physics: ComponentIdx<PhysicsComponent>
	let input: ComponentIdx<VehicleInputComponent>
	let stats: ComponentIdx<ShipStats>
	let primaryWpn: ComponentIdx<WeaponComponent>
	let secondaryWpn: ComponentIdx<WeaponComponent>
}

struct ShipStats {
	var hp: HP
	var engine: ShipEngine
	var reactor: Capacitor
	var shield: Capacitor
}

struct HP {
	var maxArmor: UInt16
	var maxStructure: UInt16

	var front: UInt16
	var side: UInt16
	var core: UInt16
	var damaged: UInt16 = 0

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

	mutating func charge() {
		value = min(maxValue, value + recharge)
	}
	mutating func charge(from capacitor: inout Capacitor) {
		if capacitor.drain(recharge) == true { charge() }
	}
	mutating func drain(_ amount: UInt16) -> Bool {
		if value >= amount {
			value -= amount
			return true
		}
		return false
	}
}

struct TargetComponent {
	var target: Entity?
}

enum Team {
	case blue
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

struct MapItem {

	enum ItemType {
		case star
		case planet
		case ally
		case enemy
	}

	let type: ItemType
	let node: SKNode
}
