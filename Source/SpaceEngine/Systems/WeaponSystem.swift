import SpriteKit
import Fx

struct WeaponSystem {

	private let world: World
	private var primaryFiringEntities = [] as Set<Entity>
	private var secondaryFiringEntities = [] as Set<Entity>

	init(world: World) {
		self.world = world
	}

	mutating func update() {
		applyInput()
		updateCooldowns()
		primaryFiringEntities = updateFiring(firing: primaryFiringEntities, weapons: world.primaryWpn)
		secondaryFiringEntities = updateFiring(firing: secondaryFiringEntities, weapons: world.secondaryWpn)
	}

	private mutating func applyInput() {
		let ships = world.ships
		let inputs = world.vehicleInput
		let primaryWpn = world.primaryWpn
		let secondaryWpn = world.secondaryWpn

		ships.enumerated().forEach { index, ship in
			let entity = ships.entityAt(index)
			let input = inputs[ship.input]

			if input.primary && primaryWpn[ship.primaryWpn].remainingCooldown == 0 {
				primaryFiringEntities.insert(entity)
			}
			if input.secondary && secondaryWpn[ship.secondaryWpn].remainingCooldown == 0 {
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
			weapon.remainingCooldown = weapon.remainingCooldown - 1
			if weapon.remainingCooldown == 0, weapon.rounds == 0 {
				weapon.rounds = weapon.roundsPerShot
			}
		}
	}

	private func updateFiring(firing: Set<Entity>, weapons: Store<WeaponComponent>) -> Set<Entity> {
		firing.filterSet { entity in
			if let index = weapons.indexOf(entity) {
				let weapon = weapons[index]

				if weapon.remainingCooldown == 0 && weapon.rounds != 0 {
					let offset = CGVector(dx: 0, dy: 12)
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
		weapon.remainingCooldown += weapon.rounds == 0 ? weapon.cooldown : weapon.perShotCooldown

		let target = world.targets.indexOf(source).map { world.targets[$0] }?.target
		let team = world.team.indexOf(source).map { world.team[$0] }
		let physics = world.physics.indexOf(source).map { world.physics[$0] }

		let v = Float(weapon.velocity) + (physics.map { Float($0.momentum.length * 64) } ?? 0)

		for round in 0..<roundsPerTick {
			ProjectileFactory.createProjectile(
				world,
				at: transform.move(by: offset(round: Int(round), outOf: Int(roundsPerTick))),
				velocity: v,
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
