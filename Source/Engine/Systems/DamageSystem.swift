import PowerCore
import SpriteKit

final class DamageSystem {

	let world: World

	init(world: World) {
		self.world = world
	}

	func damage(hp: (index: Int, entity: Entity), projectile: ProjectileComponent, point: CGPoint, normal: CGVector) {
		let spriteIndex = world.sprites.indexOf(hp.entity)!
		let sprite = world.sprites[spriteIndex].sprite
		var hpComponent = world.hp[hp.index]
		var damage = projectile.damage

		let angle = (point - sprite.position).asVector.angle - sprite.zRotation

		let eIndexes = indexes(at: angle, bound: 7)
		let eArmor = hpComponent[eIndexes.x, eIndexes.y]
		if eArmor > 0 {
			let capacity = Float(hpComponent.armor) * (Float(eArmor) / Float(UInt8.max))
			let n = max(0, capacity - damage) / Float(hpComponent.armor)
			let r = UInt8(n * Float(UInt8.max))
			damage = max(0, damage - capacity)
			hpComponent[eIndexes.x, eIndexes.y] = r
		}

		let iIndexes = indexes(at: angle, bound: 5)
		let iArmor = hpComponent[iIndexes.x + 1, iIndexes.y + 1]
		if iArmor > 0 {
			let capacity = Float(hpComponent.armor) * (Float(iArmor) / Float(UInt8.max))
			let n = max(0, capacity - damage) / Float(hpComponent.armor)
			let r = UInt8(n * Float(UInt8.max))
			damage = max(0, damage - capacity)
			hpComponent[iIndexes.x + 1, iIndexes.y + 1] = r
		}

		hpComponent.currentHP -= damage

		world.hp[hp.index] = hpComponent

		if hpComponent.currentHP < 0 {
			EffectsFabric.createVehilceExplosion(world: world, at: sprite.transform)
			let dead = DeadComponent(killedBy: projectile.source)
			world.dead.add(component: dead, to: hp.entity)
		}
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
