import SpriteKit

final class PlanetarySystem {
	private let world: World
	private let planets: Store<PlanetComponent>
	private let physics: Store<Physics>
	private let msgsys: MessageSystem

	private var visitingPlanet = Quad<Int?>(repeating: nil)

	init(world: World, msgsys: MessageSystem) {
		self.world = world
		planets = world.planets
		physics = world.physics
		self.msgsys = msgsys

		msgsys.monitor(system: .planet) { [weak msgsys] player, action in
			if action == .a {
				world.ships[player]?.hp.repair()
			}
			if action == .b {
				world.spawnEnemies()
				msgsys?.clearSystemMessages(.planet)
			}
		}
	}

	func update() {
		updatePositions()
		updateMessages()
	}

	private func updateMessages() {
		let planets = world.planets
		for index in planets.indices {
			let planet = planets[index]

			if planet.hasShop, visitingPlanet[0] != index, !planet.orbiting.isEmpty {
				visitingPlanet[0] = index
				msgsys.send(Message(
					system: .planet,
					text: "Sol \(index)\n",
					act: "Repair",
					scan: "Fight"
				))
			} else if planet.hasShop, visitingPlanet[0] == index, planet.orbiting.isEmpty {
				visitingPlanet[0] = nil
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
