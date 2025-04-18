import SpriteKit

final class DamageSystem {
	let world: World

	init(world: World) {
		self.world = world
	}

	func damage(shipRef: Ref<ShipRef>, projectile: ProjectileComponent, point: CGPoint, normal: CGVector) {
		let entity = shipRef.entity
		let shipRef = shipRef.value
		let sprite = world.sprites[shipRef.sprite].sprite
		var ship = world.ships[shipRef.ship]
		var damage = projectile.damage

		let shield = ship.shield.value
		let shieldMul = 16 as UInt16
		ship.shield.value = damage * shieldMul >= shield ? 0 : shield - damage * shieldMul
		damage = damage * shieldMul > shield ? damage - shield / shieldMul : 0

		let sa = sin((point - sprite.position).vector.angle - sprite.zRotation)
		if sa > 0.5 {
			let front = ship.hp.front
			ship.hp.front = damage >= front ? 0 : front - damage
			damage = damage > front ? damage - front : 0
		} else {
			let side = ship.hp.side
			ship.hp.side = damage >= side ? 0 : side - damage
			damage = damage > side ? damage - side : 0
		}

		if ship.hp.core > damage {
			ship.hp.core -= damage
		} else {
			ship.hp.core = 0

			EffectsFactory.createVehilceExplosion(world: world, at: sprite.transform)
			let dead = DeadComponent(killedBy: projectile.source)
			world.dead.add(component: dead, to: entity)
		}

		world.ships[shipRef.ship] = ship
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
