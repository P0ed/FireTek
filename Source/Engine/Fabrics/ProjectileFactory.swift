import SpriteKit
import PowerCore

enum ProjectileFactory {

	static func createProjectile(world: World, projectile: ProjectileComponent) -> Entity {
		let entity = world.entityManager.create()
		let sprite = SpriteFactory.createProjectileSprite(entity, type: projectile.type)
		world.sprites.add(sprite, to: entity)

		return entity
	}
}
