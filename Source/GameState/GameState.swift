struct GameState: Codable {
	var location: Location
	var player: Player
}

extension GameState {

	// MARK: Location
	struct Location: Codable {
		var position: Point
		var system: SystemLocation?
	}

	struct SystemLocation: Codable {
		var position: Point
		var systemID: Int
		var landed: LandedLocation?
	}

	struct LandedLocation: Codable {
		var planetID: Int
	}

	// MARK: Player
	struct Player: Codable {
		var ship: Ship
		var crew: [CrewMember]
		var crystals: Crystals
	}

	// MARK: Ship
	struct Ship: Codable {
		let name: String
		let hull: ShipHull
		var propulsion: ShipPropulsion
		var reactor: ShipReactor
		var shield: ShipShield
		var primaryWeapon: Weapon
		var secondaryWeapon: Weapon
	}

	enum ShipType: Int, Codable {
		case corvette
		case frigate
		case destroyer
	}

	struct ShipHull: Codable {
		let rarity: Rarity
		let type: ShipType
		let armor: Float
		let structure: Float
		let size: Int
	}

	struct ShipPropulsion: Codable {
		let rarity: Rarity
		let slots: Int
		let impulse: Float
		let warp: Float
		let efficency: Float
	}

	struct ShipReactor: Codable {
		let rarity: Rarity
		let slots: Int
		let capacity: Float
		let recharge: Float
	}

	struct ShipShield: Codable {
		let rarity: Rarity
		let slots: Int
		let capacity: Float
		let recharge: Float
		let delay: Float
		let efficency: Float
	}

	struct MissleDefence: Codable {
		let rarity: Rarity
		let slots: Int
		let rate: Float
	}

	enum WeaponType: UInt8, Codable {
		case missle
		case laser
		case shell
	}

	struct Weapon: Codable {
		let rarity: Rarity
		let slots: Int
		let type: WeaponType
		let damage: Float
		let velocity: Float
		let cooldown: Float
		let perShotCooldown: Float
		let roundsPerShot: Int
		let energyConsumption: Float
	}

	enum Rarity: UInt8, Codable {
		case common, uncommon, rare, epic
	}

	// MARK: Crew
	struct CrewMember: Codable {
		let name: String
		var rank: Int
		var stats: CrewStats
	}

	struct CrewStats: Codable {
		var attack: Int
		var defence: Int
		var engineering: Int
	}

	// MARK: Resources
	struct Crystals: Codable {
		var red: Int
		var green: Int
		var blue: Int
		var yellow: Int
		var magenta: Int
		var cyan: Int
	}
}

extension GameState.Rarity {
	var k: Float {
		switch self {
		case .common: return 1
		case .uncommon: return 1.2
		case .rare: return 1.4
		case .epic: return 1.7
		}
	}

	var lower: GameState.Rarity {
		switch self {
		case .common: return .common
		case .uncommon: return .common
		case .rare: return .uncommon
		case .epic: return .rare
		}
	}

	var higher: GameState.Rarity {
		switch self {
		case .common: return .uncommon
		case .uncommon: return .rare
		case .rare: return .epic
		case .epic: return .epic
		}
	}
}
