struct SpaceLevel {
	let starSystem: StarSystemData
	let spawnPosition: Point
}

extension SpaceLevel {

	static var `default`: SpaceLevel {
		return SpaceLevel(
			starSystem: .generate(),
			spawnPosition: Point(x: 0, y: 150)
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
					orbit: 120,
					velocity: 0.01,
					position: 0
				),
				Planet(
					radius: 40,
					color: .yellow,
					orbit: 270,
					velocity: 0.005,
					position: 0
				),
				Planet(
					radius: 36,
					color: .green,
					orbit: 390,
					velocity: 0.002,
					position: 0
				),
				Planet(
					radius: 34,
					color: .orange,
					orbit: 480,
					velocity: 0.001,
					position: 0
				)
			]
		)
	}
}
