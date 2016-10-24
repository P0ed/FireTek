import SpriteKit
import PowerCore
import Fx

struct WeaponSystem {

	private let world: World
	private var firingEntities = [] as Set<Entity>

	init(world: World) {
		self.world = world
	}

	mutating func update() {
		applyVehicleInputs()
		updateCooldowns()
		firingEntities = updateFiring()
	}

	private mutating func applyVehicleInputs() {
		let vehicles = world.vehicles
		let inputs = world.vehicleInput
		let stats = world.vehicleStats

		vehicles.enumerated().forEach { index, vehicle in
			let entity = vehicles.entityAt(index)
			let input = inputs[vehicle.input]
			if input.primaryFire && stats[vehicle.stats].weapon.remainingCooldown == 0 {
				firingEntities.insert(entity)
			}
		}
	}

	private func updateCooldowns() {
		let vehicleStats = world.vehicleStats
		vehicleStats.enumerated().forEach { index, _ in
			updateWeaponCooldown(&vehicleStats[index].weapon)
		}
	}

	private func updateWeaponCooldown(_ weapon: inout Weapon) {
		if weapon.remainingCooldown != 0 {
			weapon.remainingCooldown = max(0, weapon.remainingCooldown - Float(Engine.timeStep))
			if weapon.remainingCooldown == 0 {
				weapon.rounds = min(weapon.roundsPerShot, weapon.ammo)
			}
		}
	}

	private func updateFiring() -> Set<Entity> {
		let vehicles = world.vehicles
		let stats = world.vehicleStats
		let sprites = world.sprites

		return firingEntities.filterSet { entity in
			if let index = vehicles.indexOf(entity) {
				let vehicle = vehicles[index]
				let statsIndex = vehicle.stats.value
				let transform = sprites[vehicle.sprite].sprite.transform

				fire(&stats[statsIndex].weapon, at: transform, source: entity)

				return stats[statsIndex].weapon.rounds > 0
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

		for _ in 0..<roundsPerTick {
			ProjectileFactory.createProjectile(
				world,
				at: transform,
				projectile: ProjectileComponent(
					source: source,
					type: weapon.type,
					damage: weapon.damage
				)
			)
		}
	}
}
