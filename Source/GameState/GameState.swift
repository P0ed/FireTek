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
		var stats: ShipStats
	}

	struct ShipStats: Codable {
		let type: ShipType
		let components: ShipComponents
	}

	enum ShipType: Int, Codable {
		case corvette
		case fregate
	}

	struct ShipComponents: Codable {
		let propulsion: ShipPropulsion
	}

	struct ShipPropulsion: Codable {
		let rarity: Rarity
		let impulse: Float
	}

	struct ShipReactor: Codable {
		let rarity: Rarity
		let recharge: Float
		let capacity: Float
	}

	struct ShipShield: Codable {
		let rarity: Rarity
		let capacity: Float
	}

	struct Weapon: Codable {
		
	}

	enum Rarity: UInt8, Codable {
		case common, uncommon, rare, legendary
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
