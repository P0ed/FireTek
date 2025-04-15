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
			planets: [
				Planet(
					radius: 20,
					color: .red,
					orbit: 0,
					velocity: 0,
					angle: 0
				),
				Planet(
					radius: 10,
					color: .cyan,
					orbit: 800,
					velocity: 0.00006,
					angle: 0.2
				),
				Planet(
					radius: 12,
					color: .yellow,
					orbit: 1100,
					velocity: 0.00005,
					angle: 2.5
				),
				Planet(
					radius: 16,
					color: .green,
					orbit: 1400,
					velocity: 0.00004,
					angle: 4.1
				),
				Planet(
					radius: 14,
					color: .orange,
					orbit: 1700,
					velocity: 0.00003,
					angle: 2.9
				),
				Planet(
					radius: 12,
					color: .cyan,
					orbit: 1900,
					velocity: 0.00003,
					angle: 5.9
				),
				Planet(
					radius: 10,
					color: .blue,
					orbit: 2200,
					velocity: 0.00002,
					angle: 4.4
				),
				Planet(
					radius: 14,
					color: .orange,
					orbit: 2500,
					velocity: 0.00002,
					angle: 8.0
				),
				Planet(
					radius: 12,
					color: .green,
					orbit: 2800,
					velocity: 0.00002,
					angle: 2.3
				)
			]
		)
	}
}
