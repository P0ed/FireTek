extension GameState {
	static let random = RandomGenerator()

	static func make() -> GameState {
		GameState(
			location: createLocation(),
			ship: makeShip(name: "Von Neumann", crew: makeCrew(), rarity: .uncommon),
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

	private static func vararity(_ rarity: Rarity) -> Rarity {
		switch random.float() {
		case 0..<0.15: rarity.lower
		case 0.85..<0.95: rarity.higher
		case 0.95..<1: rarity.higher.higher
		default: rarity
		}
	}

	static func makeShip(name: String? = nil, crew: [Crew] = [], rarity: Rarity) -> Ship {
		let name = name ?? random.element(Ship.shipNames)
		let crew = !crew.isEmpty ? crew : [
			.random(friendly: false, random: random),
			.random(friendly: false, random: random)
		]
		return Ship(
			name: name,
			crew: crew,
			hull: createShipHull(rarity: rarity),
			reactor: createShipReactor(rarity: rarity),
			propulsion: createShipPropulsion(rarity: rarity),
			shield: createShipShield(rarity: rarity),
			primaryWeapon: makeBlaster(rarity: rarity),
			secondaryWeapon: makeTorpedo(rarity: rarity)
		)
	}

	static func createShipHull(rarity: Rarity) -> ShipHull {
		ShipHull(
			rarity: rarity,
			armor: random.int(40...50) * rarity.n,
			structure: random.int(30...40) * rarity.n
		)
	}

	static func createShipPropulsion(rarity: Rarity) -> ShipPropulsion {
		ShipPropulsion(
			rarity: rarity,
			impulse: random.int(18...22) + rarity.n,
			warp: random.int(12...20) + rarity.n,
			efficency: rarity.n - 1
		)
	}

	static func createShipReactor(rarity: Rarity) -> ShipReactor {
		ShipReactor(
			rarity: rarity,
			capacity: random.int(2400...3200) * rarity.n,
			recharge: random.int(6...8) + rarity.n
		)
	}

	static func createShipShield(rarity: Rarity) -> ShipShield {
		ShipShield(
			rarity: rarity,
			capacity: random.int(1600...1800) * rarity.n,
			recharge: random.int(0...1) + rarity.n
		)
	}

	static func makeLaser(rarity: Rarity) -> Weapon {
		Weapon(
			rarity: rarity,
			type: .laser,
			damage: 8 + rarity.n,
			velocity: 300,
			cooldown: 20,
			recharge: 6
		)
	}

	static func makeTorpedo(rarity: Rarity) -> Weapon {
		Weapon(
			rarity: rarity,
			type: .torpedo,
			damage: 85 + rarity.n * 6,
			velocity: 300,
			cooldown: 40,
			recharge: 20
		)
	}

	static func makeBlaster(rarity: Rarity) -> Weapon {
		Weapon(
			rarity: rarity,
			type: .blaster,
			damage: 45 + rarity.n * 3,
			velocity: 500,
			cooldown: 32,
			recharge: 16
		)
	}

	private static func makeCrew() -> [Crew] {
		[
			Crew(
				name: "Jim",
				combat: 9,
				engineering: 6,
				science: 6
			),
			Crew(
				name: "Spok",
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
