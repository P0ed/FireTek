import PowerCore
import SpriteKit
import Runes

enum EffectsFabric {

	@discardableResult
	static func createShellExplosion(world: World, at transform: Transform) -> Entity {
		let entity = world.entityManager.create()

		let textures = SpriteFactory.shellExplosionTextures()
		let sprite = SKSpriteNode(texture: textures.first)
		sprite.transform = transform

		let action = SKAction.animate(with: textures, timePerFrame: 0.1)
		sprite.run(action)

		world.sprites.add(component: SpriteComponent(sprite: sprite), to: entity)
		world.explosions.add(component: ExplosionComponent(lifetime: 60), to: entity)

		return entity
	}

	@discardableResult
	static func createVehilceExplosion(world: World, at transform: Transform) -> Entity {
		let entity = world.entityManager.create()

		let textures = SpriteFactory.vehiceExplosionTextures()
		let sprite = SKSpriteNode(texture: textures.first)
		sprite.setScale(1.5)
		sprite.transform = transform

		let action = SKAction.animate(with: textures, timePerFrame: 0.1)
		sprite.run(action)

		world.sprites.add(component: SpriteComponent(sprite: sprite), to: entity)
		world.explosions.add(component: ExplosionComponent(lifetime: 50), to: entity)

		return entity
	}
}
