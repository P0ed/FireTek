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

			if input.primary || input.secondary {
				let ship = ships[ref.ship]

				if input.primary, ship.primary.capacitor.isCharged {
					fire(&ships[ref.ship].primary, at: world.physics[ref.physics], target: ship.target, source: entity)
				}
				if input.secondary, ship.secondary.capacitor.isCharged {
					fire(&ships[ref.ship].secondary, at: world.physics[ref.physics], target: ship.target, source: entity)
				}
			}
		}
	}

	private func fire(_ weapon: inout Weapon, at physics: Physics, target: Entity?, source: Entity) {
		weapon.capacitor.discharge()

		let angle = physics.rotation
		let velocity = CGVector(dx: 0, dy: CGFloat(weapon.velocity) / 128).rotate(angle) + physics.momentum
		let offset = CGVector(dx: 0, dy: 14).rotate(angle)

		world.unitFactory.createProjectile(
			at: physics.position + offset.point,
			velocity: velocity,
			angle: physics.rotation,
			projectile: ProjectileComponent(
				source: source,
				target: target,
				type: weapon.type,
				damage: weapon.damage
			),
			team: physics.category.team
		)
	}
}
