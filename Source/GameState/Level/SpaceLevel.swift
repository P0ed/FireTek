struct SpaceLevel {
	let starSystem: StarSystemData
	let spawnPosition: Point
}

extension SpaceLevel {

	static var `default`: SpaceLevel {
		return SpaceLevel(
			starSystem: .generate(),
			spawnPosition: Point(x: 0, y: 250)
		)
	}
}

extension StarSystemData {

	static func generate() -> StarSystemData {
		return StarSystemData(
			star: Star(radius: 50, color: .red),
			planets: [
				Planet(
					radius: 30,
					color: .cyan,
					orbit: 580,
					velocity: 0.0015,
					position: 0.2
				),
				Planet(
					radius: 40,
					color: .yellow,
					orbit: 970,
					velocity: 0.00081,
					position: 2.5
				),
				Planet(
					radius: 36,
					color: .green,
					orbit: 1390,
					velocity: 0.00021,
					position: 1.1
				),
				Planet(
					radius: 34,
					color: .orange,
					orbit: 1980,
					velocity: 0.00011,
					position: 2.9
				)
			]
		)
	}
}
