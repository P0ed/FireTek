import SpriteKit

enum EffectsFabric {

	@discardableResult
	static func createShellExplosion(world: World, at transform: Transform) -> Entity {
		let entity = world.entityManager.create()

		let textures = SpriteFactory.shellExplosionTextures()
		let sprite = SKSpriteNode(texture: textures.first)
		sprite.transform = transform

		sprite.run(.group([
			.animate(with: textures, timePerFrame: 0.1),
			SoundsFabric.explosion
		]))

		world.sprites.add(component: SpriteComponent(sprite: sprite), to: entity)
		world.lifetime.add(component: LifetimeComponent(lifetime: 60), to: entity)

		return entity
	}

	@discardableResult
	static func createVehilceExplosion(world: World, at transform: Transform) -> Entity {
		let entity = world.entityManager.create()

		let textures = SpriteFactory.vehiceExplosionTextures()
		let sprite = SKSpriteNode(texture: textures.first)
		sprite.setScale(1.5)
		sprite.transform = transform

		sprite.run(.group([
			.animate(with: textures, timePerFrame: 0.1),
			SoundsFabric.vehicleExplosion
		]))

		world.sprites.add(component: SpriteComponent(sprite: sprite), to: entity)
		world.lifetime.add(component: LifetimeComponent(lifetime: 50), to: entity)

		return entity
	}
}
