import SpriteKit
import Fx

final class CollisionsSystem {
	private let world: World

	let didBeginContact: Signal<Contact>
	private let send: (Contact) -> Void

	init(world: World) {
		self.world = world

		let (beginContactStream, beginContactPipe) = Signal<Contact>.pipe()
		didBeginContact = beginContactStream
		send = beginContactPipe
	}

	func update() {
		let phy = world.physics
		let idx = phy.indices
		var contacts = [] as [Contact]

		for i in idx {
			let ip = phy[i]

			for j in idx.dropFirst(1 + i) {
				let jp = phy[j]

				if !ip.category.intersection(jp.contacts).isEmpty || !ip.contacts.intersection(jp.category).isEmpty {
					let v = (jp.position - ip.position).vector

					if v.length < 10 {
						let p = ip.position + (v / 2).point
						contacts.append(Contact(
							a: phy.entityAt(i),
							b: phy.entityAt(j),
							acat: ip.category,
							bcat: jp.category,
							point: p,
							normal: v
						))
					}
				}
			}
		}
		contacts.forEach(send)
	}
}

struct Contact {
	var a: Entity
	var b: Entity
	var acat: Category
	var bcat: Category
	var point: CGPoint
	var normal: CGVector
}
