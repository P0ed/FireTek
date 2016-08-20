import Fx
import PowerCore

struct LevelSystem {

	enum State {
		case Initial
		case InProgress(Progress)
		case GameOver(win: Bool)

		struct Progress {
			let player: Entity
		}
	}

	private var state: State
	private let world: World
	private let level: Level

	init(world: World, level: Level) {
		self.world = world
		self.level = level
		state = .Initial
	}

	mutating func update() {
		switch state {
		case .Initial:
			state = updateState(spawnUnits())
		case .InProgress(let progress):
			state = updateState(progress)
		case .GameOver:
			break
		}
	}

	private func updateState(progress: State.Progress) -> State {
		if world.vehicles.indexOf(progress.player) == nil {
			return .GameOver(win: false)
		} else {
			return .InProgress(updateProgress(progress))
		}
	}

	private func updateProgress(progress: State.Progress) -> State.Progress {
		return progress
	}

	private func spawnUnits() -> State.Progress {

		let player = UnitFactory.createPlayer(world, position: level.spawnPosition)

		return State.Progress(player: player)
	}
}
