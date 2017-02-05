import PowerCore
import SpriteKit

final class PlanetarySystem {

	let planets: Store<PlanetComponent>

	init(planets: Store<PlanetComponent>) {
		self.planets = planets
	}

	func update() {
		for index in planets.indices {
			var planet = planets[index]
			planet.position += planet.velocity
			planet.sprite.position = position(orbit: planet.orbit, angle: planet.position)
			planets[index] = planet
		}
	}

	func position(orbit: Float, angle: Float) -> CGPoint {
		return CGPoint(x: CGFloat(orbit * cos(angle)), y: CGFloat(orbit * sin(angle)))
	}
}
