import PowerCore

final class TargetSystem {

	let targets: Store<TargetComponent>

	init(targets: Store<TargetComponent>) {
		self.targets = targets
	}

	func update() {
		for index in targets.indices {
			if let target = targets[index].target, !targets.entityManager.isAlive(target) {
				targets[index].target = nil
			}
		}
	}
}
