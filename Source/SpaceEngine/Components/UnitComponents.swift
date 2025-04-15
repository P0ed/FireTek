import Fx
import SpriteKit

struct ShipComponent {
	let sprite: ComponentIdx<SpriteComponent>
	let physics: ComponentIdx<PhysicsComponent>
	let hp: ComponentIdx<HPComponent>
	let input: ComponentIdx<VehicleInputComponent>
	let stats: ComponentIdx<ShipStats>
	let primaryWpn: ComponentIdx<WeaponComponent>
	let secondaryWpn: ComponentIdx<WeaponComponent>
}

struct ShipStats {
	var speed: UInt16
}

struct TowerComponent {
	let sprite: ComponentIdx<SpriteComponent>
	let hp: ComponentIdx<HPComponent>
	let input: ComponentIdx<TowerInputComponent>
}

struct BuildingComponent {
	let sprite: ComponentIdx<SpriteComponent>
	let hp: ComponentIdx<HPComponent>
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

struct OwnerComponent {
	let entity: Entity
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
