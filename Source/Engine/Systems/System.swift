import Fx
import PowerCore
import Runes

struct CachedUnit<Storage> {
	let entity: Entity
	var store: Storage
}

extension CachedUnit: Hashable {

	var hashValue: Int {
		return entity.hashValue
	}

	static func == <A>(lhs: CachedUnit<A>, rhs: CachedUnit<A>) -> Bool {
		return lhs.entity == rhs.entity
	}
}

final class System<Unit> {

	typealias AddUnit = (CachedUnit<Unit>) -> ()
	typealias RemoveUnit = (Entity) -> ()
	typealias SetupFunction = (World, CompositeDisposable, AddUnit, RemoveUnit) -> ()
	typealias UpdateFunction = (World, [CachedUnit<Unit>]) -> ()

	let world: World
	private var units = [] as [CachedUnit<Unit>]
	private let disposable = CompositeDisposable()
	private let _update: UpdateFunction

	init(world: World, setup: SetupFunction, update: @escaping UpdateFunction) {
		self.world = world
		_update = update

		setup(
			world,
			disposable,
			{ self.units.append($0) },
			{ e in _ = {self.units.remove(at: $0)} <^> self.units.index {$0.entity == e} }
		)
	}

	func update() {
		_update(world, units)
	}
}
