import SpriteKit
import Fx

struct SpriteSpawnSystem {

	let disposable = CompositeDisposable()

	init(scene: SKScene, store: Store<PhysicsComponent>) {

		disposable += store.newComponents.observe { [unowned scene] index in
			scene.addChild(store[index].node)
		}

		disposable += store.removedComponents.observe { entity, component in
			component.node.removeFromParent()
		}
	}
}
