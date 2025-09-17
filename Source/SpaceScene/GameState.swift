import Foundation

struct PlayerState: Codable {
	var location: Location
	var ship: Ship
	var crystals: Crystals
}

enum WeaponType: UInt8, Codable {
	case torpedo
	case blaster
}

extension PlayerState {

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
		var rank: Rank
		var armor: UInt16
		var structure: UInt16
	}

	struct ShipPropulsion: Codable {
		var rank: Rank
		var impulse: UInt16
		var warp: UInt16
		var efficency: UInt16
	}

	struct ShipReactor: Codable {
		var rank: Rank
		var capacity: UInt16
		var recharge: UInt16
	}

	struct ShipShield: Codable {
		var rank: Rank
		var capacity: UInt16
		var recharge: UInt16
	}

	struct Weapon: Codable {
		var rank: Rank
		var type: WeaponType
		var damage: UInt16
		var velocity: UInt16
		var cooldown: UInt16
		var recharge: UInt16
	}

	struct Crew: Codable {
		var name: String
		var rank: Rank
		var combat: UInt16
		var engineering: UInt16
		var science: UInt16
		var traits: UInt16 = 0
	}

	struct Crystals: Codable {
		var red: UInt16
		var amber: UInt16
		var yellow: UInt16
		var cyan: UInt16
		var blue: UInt16
		var violet: UInt16
	}
}

extension PlayerState.Ship {

	func weaponComponent(_ path: KeyPath<Self, PlayerState.Weapon>) -> Weapon {
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

	var text: String {
		"""
		SHIP: \(name)
		
		CREW:
		\(crew.map(\.name).joined(separator: "\n"))
		"""
	}
}

extension PlayerState.Crystals {
	var text: String {
		"""
		
		CRYSTALS:
		red:\(red) amber:\(amber) yellow:\(yellow)
		cyan:\(cyan) blue:\(blue) violet:\(violet)
		"""
	}
}

extension PlayerState {
	var text: String {
		ship.text + "\n" + crystals.text
	}
}

extension [PlayerState.Crew] {
	var traits: UInt16 { reduce(0, { $0 | $1.traits }) }
	func n(_ path: KeyPath<PlayerState.Crew, UInt16>) -> UInt16 {
		reduce(0, { $0 + $1[keyPath: path] })
	}
}

enum Rank: UInt8, Codable { case a, b, c, d }

extension Rank {
	var n: UInt16 {
		switch self {
		case .a: return 2
		case .b: return 3
		case .c: return 5
		case .d: return 8
		}
	}
	var lower: Rank {
		switch self {
		case .a: .a
		case .b: .a
		case .c: .b
		case .d: .c
		}
	}
	var higher: Rank {
		switch self {
		case .a: .b
		case .b: .c
		case .c: .d
		case .d: .d
		}
	}
}
