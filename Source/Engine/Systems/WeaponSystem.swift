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
		applyVehicleInputs()
		updateCooldowns()
		primaryFiringEntities = updatePrimaryFiring()
		secondaryFiringEntities = updateSecondaryFiring()
	}

	private mutating func applyVehicleInputs() {
		let vehicles = world.vehicles
		let inputs = world.vehicleInput
		let stats = world.vehicleStats

		vehicles.enumerated().forEach { index, vehicle in
			let entity = vehicles.entityAt(index)
			let input = inputs[vehicle.input]

			if input.primaryFire && stats[vehicle.stats].primaryWeapon.remainingCooldown == 0 {
				primaryFiringEntities.insert(entity)
			}
			if input.secondaryFire && stats[vehicle.stats].secondaryWeapon.remainingCooldown == 0 {
				secondaryFiringEntities.insert(entity)
			}
		}
	}

	private func updateCooldowns() {
		let vehicleStats = world.vehicleStats
		vehicleStats.enumerated().forEach { index, _ in
			updateWeaponCooldown(&vehicleStats[index].primaryWeapon)
			updateWeaponCooldown(&vehicleStats[index].secondaryWeapon)
		}
	}

	private func updateWeaponCooldown(_ weapon: inout Weapon) {
		if weapon.remainingCooldown != 0 {
			weapon.remainingCooldown = max(0, weapon.remainingCooldown - Float(Engine.timeStep))
			if weapon.remainingCooldown == 0 && weapon.rounds == 0 {
				weapon.rounds = min(weapon.roundsPerShot, weapon.ammo)
			}
		}
	}

	private func updatePrimaryFiring() -> Set<Entity> {
		let vehicles = world.vehicles
		let stats = world.vehicleStats
		let sprites = world.sprites

		return primaryFiringEntities.filterSet { entity in
			if let index = vehicles.indexOf(entity) {
				let vehicle = vehicles[index]
				let statsIndex = vehicle.stats.value

				let weapon = stats[statsIndex].primaryWeapon
				if weapon.remainingCooldown == 0 && weapon.rounds != 0 {
					let offset = CGVector(dx: 0, dy: 36)
					let transform = sprites[vehicle.sprite].sprite.transform.move(by: offset)
					fire(&stats[statsIndex].primaryWeapon, at: transform, source: entity)
				}

				return stats[statsIndex].primaryWeapon.rounds > 0
			}
			else {
				return false
			}
		}
	}

	private func updateSecondaryFiring() -> Set<Entity> {
		let vehicles = world.vehicles
		let stats = world.vehicleStats
		let sprites = world.sprites

		return secondaryFiringEntities.filterSet { entity in
			if let index = vehicles.indexOf(entity) {
				let vehicle = vehicles[index]
				let statsIndex = vehicle.stats.value

				let weapon = stats[statsIndex].secondaryWeapon
				if weapon.remainingCooldown == 0 && weapon.rounds != 0 {
					let offset = CGVector(dx: 0, dy: 36)
					let transform = sprites[vehicle.sprite].sprite.transform.move(by: offset)
					fire(&stats[statsIndex].secondaryWeapon, at: transform, source: entity)
				}

				return stats[statsIndex].secondaryWeapon.rounds > 0
			}
			else {
				return false
			}
		}
	}

	private func fire(_ weapon: inout Weapon, at transform: Transform, source: Entity) {
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
