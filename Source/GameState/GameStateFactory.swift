extension GameState {

	static let random = RandomGenerator()

	static func create() -> GameState {

		let location = createLocation()
		let ship = createShip(rarity: .common, type: .corvette)
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

	private static func vararity(_ rarity: Rarity) -> Rarity {
		let value = random.float()
		return value < 0.15 ? rarity.lower : value > 0.85 ? rarity.higher : rarity
	}

	private static func createShip(rarity: Rarity, type: ShipType) -> Ship {
		return Ship(
			name: "Intruder \(random.int(upperBound: 2000))",
			hull: createShipHull(rarity: rarity, type: type),
			propulsion: createShipPropulsion(rarity: vararity(rarity), slots: 2),
			reactor: createShipReactor(rarity: vararity(rarity), slots: 2),
			shield: createShipShield(rarity: vararity(rarity), slots: 2),
			primaryWeapon: createLaserWeapon(rarity: vararity(rarity), slots: 2),
			secondaryWeapon: createLaserWeapon(rarity: vararity(rarity), slots: 2)
		)
	}

	static func createShipHull(rarity: Rarity, type: ShipType) -> ShipHull {
		let typeK: Float = {
			switch type {
			case .corvette: return 1
			case .frigate: return 1.1
			case .destroyer: return 1.3
			}
		}()

		let size: ClosedRange<Int> = {
			switch type {
			case .corvette: return 21...26
			case .frigate: return 27...32
			case .destroyer: return 33...38
			}
		}()

		return ShipHull(
			rarity: rarity,
			type: type,
			armor: random.float(20...24) * typeK * rarity.k,
			structure: random.float(10...14) * typeK * rarity.k,
			size: random.int(size)
		)
	}

	static func createShipPropulsion(rarity: Rarity, slots: Int) -> ShipPropulsion {
		return ShipPropulsion(
			rarity: rarity,
			slots: slots,
			impulse: random.float(10...12) * rarity.k,
			warp: random.float(5...7) * rarity.k.squareRoot(),
			efficency: 1 - random.float(0.1...0.2) / rarity.k
		)
	}

	static func createShipReactor(rarity: Rarity, slots: Int) -> ShipReactor {
		return ShipReactor(
			rarity: rarity,
			slots: slots,
			capacity: random.float(38...56) * rarity.k,
			recharge: random.float(2...3) * rarity.k
		)
	}

	static func createShipShield(rarity: Rarity, slots: Int) -> ShipShield {
		return ShipShield(
			rarity: rarity,
			slots: slots,
			capacity: random.float(20...25) * rarity.k,
			recharge: random.float(1.5...2) * rarity.k,
			delay: random.float(4...6) / rarity.k,
			efficency: 1 - random.float(0.2...0.35) / rarity.k
		)
	}

	static func createLaserWeapon(rarity: Rarity, slots: Int) -> Weapon {
		return Weapon(
			rarity: rarity,
			slots: slots,
			type: .laser,
			damage: 4,
			velocity: 0,
			cooldown: 2,
			perShotCooldown: 0,
			roundsPerShot: 1,
			energyConsumption: 2
		)
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
