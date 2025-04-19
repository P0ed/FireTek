import SpriteKit

enum StarSystemFactory {

	static func createSystem(world: World, data: StarSystemData) {
		data.planets.forEach { createPlanet(world: world, data: $0) }
	}

	@discardableResult
	static func createPlanet(world: World, data: StarSystemData.Planet) -> Entity {
		let entity = world.entityManager.create()

		let sprite = SpriteFactory.createPlanet(entity: entity, data: data)
		world.sprites.add(component: SpriteComponent(sprite: sprite), to: entity)

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
