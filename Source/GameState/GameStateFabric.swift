extension GameState {

	static func create() -> GameState {

		let location = createLocation()
		let ship = createShip()
		let crew = createCrew()
		let crystals = Crystals(red: 4, green: 2, blue: 3, yellow: 1, magenta: 0, cyan: 0)

		let player = Player(
			ship: ship,
			crew: crew,
			crystals: crystals
		)

		return GameState(
			location: location,
			player: player
		)
	}

	private static func createLocation() -> Location {

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

		return location
	}

	private static func createShip() -> Ship {
		let ship = Ship(
			name: "Enterprise",
			stats: GameState.ShipStats(
				type: .fregate,
				components: GameState.ShipComponents(
					propulsion: GameState.ShipPropulsion(
						rarity: .rare,
						impulse: 40
					)
				)
			)
		)

		return ship
	}

	private static func createCrew() -> [CrewMember] {

		let jim = CrewMember(
			name: "Jim",
			rank: 4,
			stats: CrewStats(
				attack: 9,
				defence: 7,
				engineering: 5
			)
		)

		let spok = CrewMember(
			name: "Spok",
			rank: 3,
			stats: CrewStats(
				attack: 7,
				defence: 6,
				engineering: 9
			)
		)

		return [jim, spok]
	}
}
