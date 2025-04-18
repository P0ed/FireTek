import SpriteKit
import Fx

final class WeaponSystem {
	private let world: World

	init(world: World) {
		self.world = world
	}

	func update() {
		let refs = world.shipRefs
		let inputs = world.input
		let ships = world.ships

		refs.enumerated().forEach { index, ref in
			let entity = refs.entityAt(index)
			let input = inputs[ref.input]

			if input.primary && ships[ref.ship].primary.capacitor.isCharged {
				fire(&ships[ref.ship].primary, at: world.physics[ref.physics], source: entity)
			}
			if input.secondary && ships[ref.ship].secondary.capacitor.isCharged {
				fire(&ships[ref.ship].secondary, at: world.physics[ref.physics], source: entity)
			}
		}
	}

	private func fire(_ weapon: inout Weapon, at physics: PhysicsComponent, source: Entity) {
		weapon.capacitor.discharge()

		let target = world.targets.indexOf(source).map { world.targets[$0] }?.target
		let team = world.team.indexOf(source).map { world.team[$0] }
		let angle = physics.rotation.radians
		let velocity = CGVector(dx: 0, dy: CGFloat(weapon.velocity)).rotate(angle) + physics.momentum
		let offset = CGVector(dx: 0, dy: 14).rotate(angle)

		ProjectileFactory.createProjectile(
			world,
			at: physics.position + offset.point,
			velocity: velocity,
			angle: physics.rotation,
			projectile: ProjectileComponent(
				source: source,
				target: target,
				type: weapon.type,
				damage: weapon.damage
			),
			team: team
		)
	}
}
