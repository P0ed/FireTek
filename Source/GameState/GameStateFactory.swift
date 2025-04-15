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
			position: Point(x: 0, y: 0),
			systemID: 0
		)
		let location = Location(
			position: Point(x: 0, y: 0),
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
			name: "\(name) \(random.int(upperBound: 2000))",
			crew: crew,
			hull: createShipHull(rarity: rarity),
			reactor: createShipReactor(rarity: vararity(rarity)),
			propulsion: createShipPropulsion(rarity: vararity(rarity)),
			shield: createShipShield(rarity: vararity(rarity)),
			primaryWeapon: makeLaser(rarity: vararity(rarity)),
			secondaryWeapon: makeLaser(rarity: vararity(rarity))
		)
	}

	static func createShipHull(rarity: Rarity) -> ShipHull {
		ShipHull(
			rarity: rarity,
			armor: UInt16(random.float(20...24) * rarity.k),
			structure: UInt16(random.float(10...14) * rarity.k),
			size: UInt16(random.int(21...26))
		)
	}

	static func createShipPropulsion(rarity: Rarity) -> ShipPropulsion {
		return ShipPropulsion(
			rarity: rarity,
			impulse: UInt16(random.float(10...12) * rarity.k),
			warp: UInt16(random.float(5...7) * rarity.k.squareRoot()),
			efficency: UInt16((1 - random.float(0.1...0.2) / rarity.k) * 32)
		)
	}

	static func createShipReactor(rarity: Rarity) -> ShipReactor {
		return ShipReactor(
			rarity: rarity,
			capacity: UInt16(random.float(38...56) * rarity.k),
			recharge: UInt16(random.float(2...3) * rarity.k)
		)
	}

	static func createShipShield(rarity: Rarity) -> ShipShield {
		return ShipShield(
			rarity: rarity,
			capacity: UInt16(random.float(20...25) * rarity.k),
			recharge: UInt16(random.float(1.5...2) * rarity.k),
			delay: UInt16(random.float(4...6) / rarity.k),
			efficency: UInt16((1 - random.float(0.2...0.35) / rarity.k) * 32)
		)
	}

	static func makeLaser(rarity: Rarity) -> Weapon {
		Weapon(
			rarity: rarity,
			type: .laser,
			damage: 4,
			velocity: 0,
			cooldown: 2,
			perShotCooldown: 0,
			roundsPerShot: 1,
			charge: 2
		)
	}

	static func makeTorpedo(rarity: Rarity) -> Weapon {
		Weapon(
			rarity: rarity,
			type: .torpedo,
			damage: 80,
			velocity: 200,
			cooldown: 40,
			perShotCooldown: 0,
			roundsPerShot: 1,
			charge: 30
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
			combat: UInt16(random.int(2...6)),
			engineering: UInt16(random.int(2...6)),
			science: UInt16(random.int(2...6))
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
