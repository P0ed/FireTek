import PowerCore
import SpriteKit
import Runes

enum EffectsFabric {

	@discardableResult
	static func createExplosion(world: World, at transform: Transform) -> Entity {
		let entity = world.entityManager.create()

		let textures = SpriteFactory.explosionTextures()
		let sprite = SKSpriteNode(texture: textures.first)
		sprite.transform = transform

		let action = SKAction.animate(with: textures, timePerFrame: 0.1)
		sprite.run(action)

		world.sprites.add(component: SpriteComponent(sprite: sprite), to: entity)
		world.explosions.add(component: ExplosionComponent(lifetime: 50), to: entity)

		return entity
	}
}
