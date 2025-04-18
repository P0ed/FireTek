import SpriteKit

enum StarSystemFactory {

	static func createSystem(world: World, data: StarSystemData) {
		data.planets.forEach { createPlanet(world: world, data: $0) }
	}

	@discardableResult
	static func createPlanet(world: World, data: StarSystemData.Planet) -> Entity {
		let entity = world.entityManager.create()
		let sprite = SpriteFactory.createPlanet(entity: entity, data: data)

		let planet = PlanetComponent(
			sprite: sprite,
			orbit: data.orbit,
			velocity: data.velocity,
			angle: data.angle
		)

		let mapItem = MapItem(type: data.orbit == 0 ? .star : .planet, node: sprite)
		world.sprites.add(component: SpriteComponent(sprite: sprite), to: entity)
		world.planets.add(component: planet, to: entity)
		world.mapItems.add(component: mapItem, to: entity)

		return entity
	}
}
