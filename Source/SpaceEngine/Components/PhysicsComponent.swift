import SpriteKit

struct PhysicsComponent {
	var body: SKPhysicsBody
	var position: CGPoint
	var rotation: Angle = .zero
	var momentum: CGVector = .zero
	var size: CGFloat = 1
	var driving: Int = 0
	var warping: Bool = false
}
