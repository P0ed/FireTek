struct WeaponComponent {
	let type: WeaponType
	let damage: UInt16
	let velocity: UInt16
	let recharge: UInt16
	let cooldown: UInt16
	let perShotCooldown: UInt16
	let roundsPerShot: UInt16
	var remainingCooldown: UInt16
	var rounds: UInt16

	init(type: WeaponType, damage: UInt16, velocity: UInt16, recharge: UInt16, cooldown: UInt16, perShotCooldown: UInt16, roundsPerShot: UInt16) {
		self.type = type
		self.damage = damage
		self.velocity = velocity
		self.recharge = recharge
		self.cooldown = cooldown
		self.perShotCooldown = perShotCooldown
		self.roundsPerShot = roundsPerShot
		remainingCooldown = cooldown
		rounds = 0
	}
}

struct ProjectileComponent {
	var source: Entity
	var target: Entity?
	var type: WeaponType
	var damage: UInt16
}
