import SpriteKit

enum StarSystemFactory {

	static func createSystem(world: World, data: StarSystemData) {
		data.planets.forEach { createPlanet(world: world, data: $0) }
	}

	@discardableResult
	static func createPlanet(world: World, data: StarSystemData.Planet) -> Entity {
		let entity = world.entityManager.create()

		let sprite = SpriteFactory.createPlanet(entity: entity, data: data)
		let physics = PhysicsComponent(node: sprite, position: data.position)

		let pidx = world.physics.add(component: physics, to: entity)
		let phyRef = world.physics.sharedIndexAt(pidx)

		let planet = PlanetComponent(
			physics: phyRef,
			orbit: data.orbit,
			velocity: data.velocity,
			angle: data.angle
		)
		world.planets.add(component: planet, to: entity)

		return entity
	}
}

extension StarSystemData {

	static func generate() -> StarSystemData {
		StarSystemData(
			planets: [
				Planet(
					radius: 28,
					color: .red,
					orbit: 0,
					velocity: 0,
					angle: 0
				),
				Planet(
					radius: 14,
					color: .cyan,
					orbit: 800,
					velocity: 0.00021,
					angle: 0.2
				),
				Planet(
					radius: 16,
					color: .yellow,
					orbit: 1100,
					velocity: 0.00013,
					angle: 2.5
				),
				Planet(
					radius: 20,
					color: .green,
					orbit: 1400,
					velocity: 0.00008,
					angle: 4.1
				),
				Planet(
					radius: 18,
					color: .orange,
					orbit: 1700,
					velocity: 0.00006,
					angle: 2.9
				),
				Planet(
					radius: 24,
					color: .cyan,
					orbit: 2000,
					velocity: 0.00005,
					angle: 5.9
				),
				Planet(
					radius: 18,
					color: .blue,
					orbit: 2200,
					velocity: 0.00014,
					angle: 4.4
				),
				Planet(
					radius: 22,
					color: .orange,
					orbit: 2400,
					velocity: 0.00004,
					angle: 8.0
				),
				Planet(
					radius: 18,
					color: .green,
					orbit: 2700,
					velocity: 0.00003,
					angle: 2.3
				),
				Planet(
					radius: 16,
					color: .magenta,
					orbit: 2900,
					velocity: 0.00013,
					angle: 1.1
				),
				Planet(
					radius: 14,
					color: .yellow,
					orbit: 3200,
					velocity: 0.00003,
					angle: 4.2
				)
			]
		)
	}
}
