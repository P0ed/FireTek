extension GameState {
	static let random = RandomGenerator()

	static func make() -> GameState {
		GameState(
			location: createLocation(),
			ship: makeShip(name: "Von Neumann", crew: makeCrew(), rank: .b),
			crystals: Crystals(red: 4, green: 2, blue: 3, yellow: 1, magenta: 0, cyan: 0)
		)
	}

	private static func createLocation() -> Location {

		let systemLocation = SystemLocation(
			position: CGPoint(x: 0, y: 0),
			systemID: 0
		)
		let location = Location(
			position: CGPoint(x: 0, y: 0),
			system: systemLocation
		)

		return location
	}

	private static func varank(_ rank: Rank) -> Rank {
		switch random.float() {
		case 0..<0.15: rank.lower
		case 0.85..<0.95: rank.higher
		case 0.95..<1: rank.higher.higher
		default: rank
		}
	}

	static func makeShip(name: String? = nil, crew: [Crew] = [], rank: Rank) -> Ship {
		let name = name ?? random.element(Ship.shipNames)
		let crew = !crew.isEmpty ? crew : [
			.random(friendly: false, random: random),
			.random(friendly: false, random: random)
		]
		return Ship(
			name: name,
			crew: crew,
			hull: createShipHull(rank: rank),
			reactor: createShipReactor(rank: rank),
			propulsion: createShipPropulsion(rank: rank),
			shield: createShipShield(rank: rank),
			primaryWeapon: makeBlaster(rank: rank),
			secondaryWeapon: makeTorpedo(rank: rank)
		)
	}

	static func createShipHull(rank: Rank) -> ShipHull {
		ShipHull(
			rank: rank,
			armor: random.int(40...50) * rank.n,
			structure: random.int(30...40) * rank.n
		)
	}

	static func createShipPropulsion(rank: Rank) -> ShipPropulsion {
		ShipPropulsion(
			rank: rank,
			impulse: random.int(18...22) + rank.n,
			warp: random.int(12...20) + rank.n,
			efficency: rank.n - 1
		)
	}

	static func createShipReactor(rank: Rank) -> ShipReactor {
		ShipReactor(
			rank: rank,
			capacity: random.int(2400...3200) * rank.n,
			recharge: random.int(6...8) + rank.n
		)
	}

	static func createShipShield(rank: Rank) -> ShipShield {
		ShipShield(
			rank: rank,
			capacity: random.int(1600...1800) * rank.n,
			recharge: random.int(0...1) + rank.n
		)
	}

	static func makeTorpedo(rank: Rank) -> Weapon {
		Weapon(
			rank: rank,
			type: .torpedo,
			damage: 85 + rank.n * 6,
			velocity: 320 + rank.n * 3,
			cooldown: 40,
			recharge: 20 + rank.n
		)
	}

	static func makeBlaster(rank: Rank) -> Weapon {
		Weapon(
			rank: rank,
			type: .blaster,
			damage: 45 + rank.n * 3,
			velocity: 500 + rank.n * 4,
			cooldown: 32 - rank.n / 2,
			recharge: 16 + rank.n / 3
		)
	}

	private static func makeCrew() -> [Crew] {
		[
			Crew(
				name: "Jim",
				rank: .d,
				combat: 9,
				engineering: 6,
				science: 6
			),
			Crew(
				name: "Spok",
				rank: .d,
				combat: 8,
				engineering: 8,
				science: 9
			)
		]
	}
}

private extension GameState.Ship {
	static let shipNames: [String] = [
		"ISS Horizon",
		"USS Pathfinder",
		"Nova’s Edge",
		"Solar Warden",
		"Chrono Wraith",
		"Dagger of Zarnak",
		"The Auroral Ark",
		"The Tranquility",
		"The Xenon Bloom",
		"Eclipse Fang",
	]
}

extension GameState.Crew {

	static func random(friendly: Bool, random: RandomGenerator) -> Self {
		.init(
			name: random.element(friendly ? friendlyNames : hostileNames),
			rank: random.bool() ? .a : .b,
			combat: random.int(2...6),
			engineering: random.int(2...6),
			science: random.int(2...6)
		)
	}

	static let friendlyNames: [String] = [
		"Captain Mirael",
		"Commander Jarek",
		"T'Lora",
		"Dr. Ilyra",
		"Kovek",
		"Engineer Selix",
		"Pilot Treya",
		"Navigator Orlin",
		"Lt. Lorana",
		"Ensign Arjin",
		"Ryla",
		"Veltris",
		"Ambassador Saelor",
		"Torvak",
		"First Officer Marex"
	]

	static let hostileNames: [String] = [
		"Zarnak the Devourer",
		"High Warlord Draxil",
		"Xenth",
		"Overseer Noraq",
		"Brax",
		"Zerel",
		"General Vorn",
		"Inquisitor Malra",
		"Korin the Silent",
		"Charek the Unseen",
		"Yalara of the Void",
		"Xivon",
		"Bloodpriest Quarn",
		"Thessa of the Blight",
		"Voidbringer Selix"
	]
}
