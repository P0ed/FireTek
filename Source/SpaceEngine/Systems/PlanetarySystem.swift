import SpriteKit

final class PlanetarySystem {
	private let planets: Store<PlanetComponent>
	private let physics: Store<Physics>
	private var messages = Quad<Int?>(repeating: nil)
	private let msgsys: MessageSystem

	init(planets: Store<PlanetComponent>, physics: Store<Physics>, msgsys: MessageSystem) {
		self.planets = planets
		self.physics = physics
		self.msgsys = msgsys
	}

	func update() {
		updatePositions()
		updateMessages()
	}

	private func updateMessages() {
		for index in planets.indices {
			let planet = planets[index]

			if planet.hasShop, messages[0] == nil, !planet.orbiting.isEmpty {
				messages[0] = index
				msgsys.send(Message(system: .planet, text: index != 0 ? "Sol \(index)" : "Sol"))
			} else if planet.hasShop, messages[0] == index, planet.orbiting.isEmpty {
				messages[0] = nil
				msgsys.clearSystemMessages(.planet)
			}
		}
	}

	private func updatePositions() {
		for index in planets.indices {
			var planet = planets[index]
			let oldPos = planet.position
			var newPos = oldPos

			if planet.orbit != 0 {
				planet.angle = planet.angle + planet.velocity
				newPos = planet.position
				planets[index] = planet
				physics[planet.physics].position = newPos
			}

			for pidx in physics.indices {
				let phy = physics[pidx]
				let shipv = ((newPos - oldPos).vector - phy.momentum).length
				let r = planet.position.distance(to: phy.position)

				if r > 39.0, r < 680.0 {
					let dv = 64.0 / r / r
					let v = (planet.position - phy.position).vector.normalized
					physics[pidx].momentum += v * dv

					if
						phy.category.contains(.player), r > 43 || shipv > 0.33,
						let idx = planet.orbiting.firstIndex(of: physics.entityAt(pidx)) {

						planet.orbiting.remove(at: idx)
						planets[index] = planet
					}
				} else {
					if
						r < 39, shipv < 0.27, phy.category.contains(.player),
						!planet.orbiting.contains(physics.entityAt(pidx)) {

						planet.orbiting.append(physics.entityAt(pidx))
						planets[index] = planet
					}
				}
			}
		}
	}
}
