import SpriteKit
import PowerCore
import Fx

struct WeaponSystem {

	private let world: World
	private var primaryFiringEntities = [] as Set<Entity>
	private var secondaryFiringEntities = [] as Set<Entity>

	init(world: World) {
		self.world = world
	}

	mutating func update() {
		applyShipsInputs()
		updateCooldowns()
		primaryFiringEntities = updateFiring(firing: primaryFiringEntities, weapons: world.primaryWpn)
		secondaryFiringEntities = updateFiring(firing: secondaryFiringEntities, weapons: world.secondaryWpn)
	}

	private mutating func applyShipsInputs() {
		let ships = world.ships
		let inputs = world.shipInput
		let primaryWpn = world.primaryWpn
		let secondaryWpn = world.secondaryWpn

		ships.enumerated().forEach { index, ship in
			let entity = ships.entityAt(index)
			let input = inputs[ship.input]

			if input.primaryFire && primaryWpn[ship.primaryWpn].remainingCooldown == 0 {
				primaryFiringEntities.insert(entity)
			}
			if input.secondaryFire && secondaryWpn[ship.secondaryWpn].remainingCooldown == 0 {
				secondaryFiringEntities.insert(entity)
			}
		}
	}

	private func updateCooldowns() {
		for index in world.primaryWpn.indices {
			updateWeaponCooldown(&world.primaryWpn[index])
		}
		for index in world.secondaryWpn.indices {
			updateWeaponCooldown(&world.secondaryWpn[index])
		}
	}

	private func updateWeaponCooldown(_ weapon: inout WeaponComponent) {
		if weapon.remainingCooldown != 0 {
			weapon.remainingCooldown = max(0, weapon.remainingCooldown - Float(SpaceEngine.timeStep))
			if weapon.remainingCooldown == 0 && weapon.rounds == 0 {
				weapon.rounds = min(weapon.roundsPerShot, weapon.ammo)
			}
		}
	}

	private func updateFiring(firing: Set<Entity>, weapons: Store<WeaponComponent>) -> Set<Entity> {
		return firing.filterSet { entity in
			if let index = weapons.indexOf(entity) {
				let weapon = weapons[index]

				if weapon.remainingCooldown == 0 && weapon.rounds != 0 {
					let offset = CGVector(dx: 0, dy: 36)
					if let spriteIndex = world.sprites.indexOf(entity) {
						let transform = world.sprites[spriteIndex].sprite.transform.move(by: offset)
						fire(&weapons[index], at: transform, source: entity)
					}
					else {
						return false
					}
				}
				return weapons[index].rounds > 0
			}
			else {
				return false
			}
		}
	}

	private func fire(_ weapon: inout WeaponComponent, at transform: Transform, source: Entity) {
		let roundsPerTick = weapon.perShotCooldown == 0 ? weapon.rounds : 1

		weapon.rounds -= roundsPerTick
		weapon.ammo -= roundsPerTick
		weapon.remainingCooldown += weapon.rounds == 0 ? weapon.cooldown : weapon.perShotCooldown

		for round in 0..<roundsPerTick {
			ProjectileFactory.createProjectile(
				world,
				at: transform.move(by: offset(round: round, outOf: roundsPerTick)),
				velocity: weapon.velocity,
				projectile: ProjectileComponent(
					source: source,
					type: weapon.type,
					damage: weapon.damage
				)
			)
		}
	}

	private func offset(round: Int, outOf total: Int) -> CGVector {
		if total == 1 { return .zero }

		let spacing = 4 as CGFloat
		let spread = spacing * CGFloat(total - 1)

		return CGVector(
			dx: (-spread / 2) + spacing * CGFloat(round),
			dy: 0
		)
	}
}
