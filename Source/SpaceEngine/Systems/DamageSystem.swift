import SpriteKit

final class DamageSystem {
	let world: World

	init(world: World) {
		self.world = world
	}

	func damage(hp: Ref<HPComponent>, projectile: ProjectileComponent, point: CGPoint, normal: CGVector) {
		let spriteIndex = world.sprites.indexOf(hp.entity)!
		let sprite = world.sprites[spriteIndex].sprite
		var hpComponent = hp.value
		var damage = projectile.damage

		let angle = (point - sprite.position).vector.angle - sprite.zRotation

		let eIndexes = indexes(at: angle, bound: 7)
		let eArmor = hpComponent[eIndexes.x, eIndexes.y]
		if hpComponent.armor > 0 && eArmor > 0 {
			let capacity = UInt16(Float(hpComponent.armor) * Float(eArmor) / Float(UInt8.max))
			let norm = Float(capacity > damage ? capacity - damage : 0) / Float(hpComponent.armor)
			let rem = UInt8(norm * Float(UInt8.max))
			damage = damage > capacity ? damage - capacity : 0
			hpComponent[eIndexes.x, eIndexes.y] = rem
		}

		let iIndexes = indexes(at: angle, bound: 5)
		let iArmor = hpComponent[iIndexes.x + 1, iIndexes.y + 1]
		if hpComponent.armor > 0 && iArmor > 0 {
			let capacity = UInt16(Float(hpComponent.armor) * Float(iArmor) / Float(UInt8.max))
			let norm = Float(capacity > damage ? capacity - damage : 0) / Float(hpComponent.armor)
			let rem = UInt8(norm * Float(UInt8.max))
			damage = damage > capacity ? damage - capacity : 0
			hpComponent[iIndexes.x + 1, iIndexes.y + 1] = rem
		}

		if hpComponent.currentHP > damage {
			hpComponent.currentHP -= damage
		} else {
			hpComponent.currentHP = 0

			EffectsFactory.createVehilceExplosion(world: world, at: sprite.transform)
			let dead = DeadComponent(killedBy: projectile.source)
			world.dead.add(component: dead, to: hp.entity)
		}

		hp.value = hpComponent
	}
}

private extension DamageSystem {

	func indexes(at angle: CGFloat, bound: Int) -> (x: Int, y: Int) {

		let q = CGFloat.pi / 4
		let w = sin(q)

		func normalize(_ x: CGFloat) -> CGFloat { return (x + w) / (2 * w) }

		switch (sin(angle), cos(angle)) {
		case (let s, let c) where c >= w:
			let y = Int((1 - normalize(s)) * CGFloat(bound))
			return (bound - 1, y)
		case (let s, let c) where s >= w:
			let x = Int(normalize(c) * CGFloat(bound))
			return (x, 0)
		case (let s, let c) where c <= -w:
			let y = Int((1 - normalize(s)) * CGFloat(bound))
			return (0, y)
		case (let s, let c) where s <= -w:
			let x = Int(normalize(c) * CGFloat(bound))
			return (x, bound - 1)
		default:
			fatalError()
		}
	}
}
