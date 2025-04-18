import SpriteKit
import Fx

final class Engine {
	@MutableProperty
	private(set) var state: GameState

	var restart: () -> Void {
		get { levelSystem.restart }
		set { levelSystem.restart = newValue }
	}

	private unowned let scene: BattleScene
	private let world: World

	private let levelSystem: LevelSystem
	private let spriteSpawnSystem: SpriteSpawnSystem
	private let inputSystem: InputSystem
	private let physicsSystem: PhysicsSystem
	private let collisionsSystem: CollisionsSystem
	private let damageSystem: DamageSystem
	private let targetSystem: TargetSystem
	private var aiSystem: AISystem
	private let cameraSystem: CameraSystem
	private var weaponSystem: WeaponSystem
	private let projectileSystem: ProjectileSystem
	private let lifetimeSystem: LifetimeSystem
	private let lootSystem: LootSystem
	private let hudSystem: HUDSystem
	private let planetarySystem: PlanetarySystem
	private let particleSystem: ParticleSystem

	init(scene: BattleScene, input: InputController) {
		let state = GameState.make()
		let world = World()
		self.state = state
		self.world = world
		self.scene = scene
		let cam = scene.camera!

		spriteSpawnSystem = SpriteSpawnSystem(scene: scene, store: world.sprites)
		levelSystem = LevelSystem(world: world, state: state)
		physicsSystem = PhysicsSystem(world: world)
		collisionsSystem = CollisionsSystem(scene: scene)

		weaponSystem = WeaponSystem(world: world)
		damageSystem = DamageSystem(world: world)
		projectileSystem = ProjectileSystem(world: world, collisionsSystem: collisionsSystem, damageSystem: damageSystem)

		inputSystem = InputSystem(world: world, player: levelSystem.player, inputController: input)
		targetSystem = TargetSystem(world: world, player: levelSystem.player, inputController: input)
		aiSystem = AISystem(world: world)

		lifetimeSystem = LifetimeSystem(world: world)

		lootSystem = LootSystem(world: world, collisionsSystem: collisionsSystem)

		cameraSystem = CameraSystem(player: world.sprites[0].sprite, camera: cam)
		cameraSystem.update()

		hudSystem = HUDSystem(world: world, player: levelSystem.player, hudNode: scene.hud)

		planetarySystem = PlanetarySystem(planets: world.planets, physics: world.physics)
		particleSystem = ParticleSystem(
			camera: cam,
			ref: world.physics.weakRefOf(levelSystem.player)
		)
	}

	func simulate() {
		inputSystem.update()
		physicsSystem.update()
		planetarySystem.update()

		weaponSystem.update()
		targetSystem.update()

		projectileSystem.update()

		levelSystem.update()
		aiSystem.update()

		hudSystem.update()
		particleSystem.update()

		lootSystem.update()
		lifetimeSystem.update()
	}

	func didFinishUpdate() {
		cameraSystem.update()
	}
}

extension CFTimeInterval {
	static let timeStep: Self = 1.0 / 60.0
}

extension MutableProperty {
	var io: IO<A> { .init(get: { self.value }, set: { self.value = $0 }) }
}
