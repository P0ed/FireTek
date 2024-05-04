import SpriteKit
import Fx

struct MenuItem {
	let text: String
	let action: () -> Void
}

extension MenuItem {

	var asTableItem: TableItem {
		let height = 44 as CGFloat

		return TableItem(
			create: {
				let node = SKSpriteNode(color: SKColor(hex: 0x333333), size: .zero)

				return TableItemUI(
					node: node,
					layout: { width in
						node.size = CGSize(width: width, height: height)
					},
					setHighlighted: { highlighted in
						node.color = SKColor(hex: highlighted ? 0x333333 : 0x555555)
					}
				)
			},
			height: const(height),
			select: action
		)
	}
}
