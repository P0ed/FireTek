import Fx
import PowerCore

struct ShipComponent {
	let sprite: Box<Int>
	let physics: Box<Int>
	let hp: Box<Int>
	let input: Box<Int>
	let stats: Box<Int>
	let primaryWpn: Box<Int>
	let secondaryWpn: Box<Int>
}

struct VehicleComponent {
	let sprite: Box<Int>
	let physics: Box<Int>
	let hp: Box<Int>
	let input: Box<Int>
	let stats: Box<Int>
	let weapon: Box<Int>
}

struct VehicleStats {
	let speed: Float
}

struct TowerComponent {
	let sprite: Box<Int>
	let hp: Box<Int>
	let input: Box<Int>
}

struct BuildingComponent {
	let sprite: Box<Int>
	let hp: Box<Int>
}

struct TargetComponent {
	var target: Entity?

	static let none = TargetComponent(target: nil)
}

enum Team {
	case blue
	case red
}

enum Crystal {
	case blue, red, purple, cyan, yellow, green, orange
}

struct CrystalComponent {
	let crystal: Crystal
}

struct LootComponent {
	let crystal: Crystal
	let count: Int8
}

struct OwnerComponent {
	let entity: Entity
}

struct DeadComponent {
	let killedBy: Entity
}
