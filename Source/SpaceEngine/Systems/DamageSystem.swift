import SpriteKit

final class DamageSystem {
	let world: World

	init(world: World) {
		self.world = world
	}

	func damage(ship: Ref<ShipComponent>, projectile: ProjectileComponent, point: CGPoint, normal: CGVector) {
		let shipc = ship.value
		let sprite = world.sprites[shipc.sprite].sprite
		var stats = world.shipStats[shipc.stats]
		var damage = projectile.damage

		let sa = sin((point - sprite.position).vector.angle - sprite.zRotation)
		if sa > 0.5 {
			let front = stats.hp.front
			stats.hp.front = damage >= front ? 0 : front - damage
			damage = damage > front ? damage - front : 0
		} else {
			let side = stats.hp.side
			stats.hp.side = damage >= side ? 0 : side - damage
			damage = damage > side ? damage - side : 0
		}

		if stats.hp.core > damage {
			stats.hp.core -= damage
		} else {
			stats.hp.core = 0

			EffectsFactory.createVehilceExplosion(world: world, at: sprite.transform)
			let dead = DeadComponent(killedBy: projectile.source)
			world.dead.add(component: dead, to: ship.entity)
		}

		world.shipStats[shipc.stats] = stats
	}
}

private extension DamageSystem {

	func indexes(at angle: CGFloat, bound: Int) -> (x: Int, y: Int) {

		let q = CGFloat.pi / 4
		let w = sin(q)

		func normalize(_ x: CGFloat) -> CGFloat { (x + w) / (2 * w) }

		switch (sin(angle), cos(angle)) {
		case (let s, let c) where c >= w:
			return (bound - 1, Int((1 - normalize(s)) * CGFloat(bound)))
		case (let s, let c) where s >= w:
			return (Int(normalize(c) * CGFloat(bound)), 0)
		case (let s, let c) where c <= -w:
			return (0, Int((1 - normalize(s)) * CGFloat(bound)))
		case (let s, let c) where s <= -w:
			return (Int(normalize(c) * CGFloat(bound)), bound - 1)
		default:
			fatalError()
		}
	}
}
