import Foundation

struct GameState: Codable {
	var location: Location
	var ship: Ship
	var crystals: Crystals
}

enum WeaponType: UInt8, Codable {
	case torpedo
	case laser
	case blaster
}

extension GameState {

	struct Location: Codable {
		var position: CGPoint
		var system: SystemLocation?
	}

	struct SystemLocation: Codable {
		var position: CGPoint
		var systemID: Int
	}

	struct Ship: Codable {
		var name: String
		var crew: [Crew]
		var hull: ShipHull
		var reactor: ShipReactor
		var propulsion: ShipPropulsion
		var shield: ShipShield
		var primaryWeapon: Weapon
		var secondaryWeapon: Weapon
	}

	struct ShipHull: Codable {
		var rarity: Rarity
		var armor: UInt16
		var structure: UInt16
	}

	struct ShipPropulsion: Codable {
		var rarity: Rarity
		var impulse: UInt16
		var warp: UInt16
		var efficency: UInt16
	}

	struct ShipReactor: Codable {
		var rarity: Rarity
		var capacity: UInt16
		var recharge: UInt16
	}

	struct ShipShield: Codable {
		var rarity: Rarity
		var capacity: UInt16
		var recharge: UInt16
		var delay: UInt16
	}

	struct Weapon: Codable {
		var rarity: Rarity
		var type: WeaponType
		var damage: UInt16
		var velocity: UInt16
		var cooldown: UInt16
		var recharge: UInt16
	}

	enum Rarity: UInt8, Codable {
		case common, uncommon, rare, epic, unknown
	}

	struct Crew: Codable {
		var name: String
		var combat: UInt16
		var engineering: UInt16
		var science: UInt16
		var traits: UInt16 = 0
	}

	struct Crystals: Codable {
		var red: UInt16
		var green: UInt16
		var blue: UInt16
		var yellow: UInt16
		var magenta: UInt16
		var cyan: UInt16
	}
}

extension GameState.Ship {

	func weaponComponent(_ path: KeyPath<Self, GameState.Weapon>) -> Weapon {
		let wpn = self[keyPath: path]

		return Weapon(
			type: wpn.type,
			damage: wpn.damage,
			velocity: wpn.velocity,
			capacitor: Capacitor(
				value: wpn.cooldown * wpn.recharge,
				recharge: wpn.recharge
			)
		)
	}

	var stats: Ship {
		Ship(
			hp: HP(
				armor: hull.armor,
				structure: hull.structure
			),
			engine: ShipEngine(
				impulse: propulsion.impulse,
				warp: propulsion.warp,
				efficiency: propulsion.efficency
			),
			reactor: Capacitor(
				value: reactor.capacity,
				recharge: reactor.recharge
			),
			shield: Capacitor(
				value: shield.capacity,
				recharge: shield.recharge
			),
			primary: weaponComponent(\.primaryWeapon),
			secondary: weaponComponent(\.secondaryWeapon)
		)
	}
}

extension [GameState.Crew] {
	var traits: UInt16 { reduce(0, { $0 | $1.traits }) }
	func n(_ path: KeyPath<GameState.Crew, UInt16>) -> UInt16 {
		reduce(0, { $0 + $1[keyPath: path] })
	}
}

extension GameState.Rarity {
	var k: Float {
		switch self {
		case .common: return 1
		case .uncommon: return 1.4
		case .rare: return 1.7
		case .epic: return 2
		case .unknown: return 2.2
		}
	}
	var n: UInt16 {
		switch self {
		case .common: return 2
		case .uncommon: return 3
		case .rare: return 5
		case .epic: return 8
		case .unknown: return 13
		}
	}
	var lower: GameState.Rarity {
		switch self {
		case .common: .common
		case .uncommon: .common
		case .rare: .uncommon
		case .epic: .rare
		case .unknown: .epic
		}
	}
	var higher: GameState.Rarity {
		switch self {
		case .common: .uncommon
		case .uncommon: .rare
		case .rare: .epic
		case .epic: .unknown
		case .unknown: .unknown
		}
	}
}
