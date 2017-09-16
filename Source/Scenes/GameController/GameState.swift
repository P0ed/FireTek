struct GameState: Codable {
	var location: Location
	var player: Player
}

extension GameState {

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

	struct Player: Codable {
		var ship: Ship
		var crew: [CrewMember]
	}

	struct Ship: Codable {

	}

	struct CrewMember: Codable {
		var name: String
		var stats: CrewStats
	}

	struct CrewStats: Codable {
		var attack: Int
		var defence: Int
		var engineering: Int
	}
}

extension GameState {

	static func create() -> GameState {

		let landedLocation = LandedLocation(planetID: 0)

		let systemLocation = SystemLocation(
			position: Point(x: 0, y: 0),
			systemID: 0,
			landed: landedLocation
		)

		let location = Location(
			position: Point(x: 0, y: 0),
			system: systemLocation
		)

		let ship = Ship()

		let jim = CrewMember(
			name: "Jim",
			stats: CrewStats(
				attack: 9,
				defence: 7,
				engineering: 5
			)
		)

		let spok = CrewMember(
			name: "Spok",
			stats: CrewStats(
				attack: 7,
				defence: 6,
				engineering: 9
			)
		)

		let player = Player(
			ship: ship,
			crew: [jim, spok]
		)

		return GameState(
			location: location,
			player: player
		)
	}
}
