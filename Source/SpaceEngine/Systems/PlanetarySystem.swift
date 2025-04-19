import SpriteKit

final class PlanetarySystem {
	private let planets: Store<PlanetComponent>
	private let physics: Store<PhysicsComponent>

	init(planets: Store<PlanetComponent>, physics: Store<PhysicsComponent>) {
		self.planets = planets
		self.physics = physics
	}

	func update() {
		for index in planets.indices {
			let planet = planets[index]
			let planetPosition = planet.position

			if planet.orbit != 0 {
				planets[index].angle += planet.velocity
				physics[planet.physics].position = planetPosition
			}

			for idx in physics.indices {
				let p = physics[idx]
				let r = planetPosition.distance(to: p.position)
				if r > 40.0, r < 640.0 {
					let dv = 96.0 / r / r
					let v = (planetPosition - p.position).vector.normalized
					physics[idx].momentum += v * dv
				}
			}
		}
	}
}
