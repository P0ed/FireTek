import PowerCore

enum ProjectileType {
	case shell
	case missle
	case homingMissle(Entity)
}

struct Weapon {

	let type: ProjectileType
	let damage: Float
	let velocity: Float
	let cooldown: Float
	let perShotCooldown: Float
	var remainingCooldown: Float
	let maxAmmo: Int
	var ammo: Int
	let roundsPerShot: Int
	var rounds: Int

	init(type: ProjectileType, damage: Float, velocity: Float, cooldown: Float, perShotCooldown: Float, roundsPerShot: Int, maxAmmo: Int) {
		self.type = type
		self.damage = damage
		self.velocity = velocity
		self.cooldown = cooldown
		self.perShotCooldown = perShotCooldown
		remainingCooldown = 0
		self.maxAmmo = maxAmmo
		ammo = maxAmmo
		self.roundsPerShot = roundsPerShot
		rounds = roundsPerShot
	}
}

struct ProjectileComponent {
	let source: Entity
	let type: ProjectileType
	let damage: Float
}
