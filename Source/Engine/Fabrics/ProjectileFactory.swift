import SpriteKit
import PowerCore

enum ProjectileFactory {

	@discardableResult
	static func createProjectile(_ world: World, at position: Transform, projectile: ProjectileComponent) -> Entity {
		let entity = world.entityManager.create()
		let sprite = SpriteFactory.createProjectileSprite(entity, type: projectile.type)
		sprite.sprite.transform = position
		world.sprites.add(component: sprite, to: entity)

		return entity
	}
}
