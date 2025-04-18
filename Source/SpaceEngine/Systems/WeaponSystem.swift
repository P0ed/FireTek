import SpriteKit
import Fx

final class WeaponSystem {
	private let world: World

	init(world: World) {
		self.world = world
	}

	func update() {
		applyInput()
	}

	private func applyInput() {
		let refs = world.shipRefs
		let inputs = world.input
		let ships = world.ships

		refs.enumerated().forEach { index, ref in
			let entity = refs.entityAt(index)
			let input = inputs[ref.input]

			var ship = ships[ref.ship]

			if input.primary && ships[ref.ship].primary.capacitor.isCharged {
				let offset = CGVector(dx: 0, dy: 12)
				let transform = world.sprites[ref.sprite].sprite.transform.move(by: offset)
				fire(&ship.primary, at: transform, source: entity)
				ships[ref.ship] = ship
			}
			if input.secondary && ships[ref.ship].secondary.capacitor.isCharged {
				let offset = CGVector(dx: 0, dy: 12)
				let transform = world.sprites[ref.sprite].sprite.transform.move(by: offset)
				fire(&ship.secondary, at: transform, source: entity)
				ships[ref.ship] = ship
			}
		}
	}

	private func fire(_ weapon: inout Weapon, at transform: Transform, source: Entity) {
		weapon.capacitor.discharge()

		let target = world.targets.indexOf(source).map { world.targets[$0] }?.target
		let team = world.team.indexOf(source).map { world.team[$0] }
		let physics = world.physics.indexOf(source).map { world.physics[$0] }
		let velocity = CGFloat(weapon.velocity) + (physics.map { CGFloat($0.momentum.length * 64) } ?? 0)

		ProjectileFactory.createProjectile(
			world,
			at: transform,
			velocity: velocity,
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
