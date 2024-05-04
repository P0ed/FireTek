import SpriteKit
import Fx

struct TableItem {
	let create: () -> TableItemUI
	let height: () -> CGFloat
	let select: () -> Void
}

struct TableItemUI {
	let node: SKNode
	let layout: (CGFloat) -> Void
	let setHighlighted: (Bool) -> Void
}

private struct TableState {
	var items: [TableItem]
	var highlighted: Int?
	var offset: CGFloat
	var heights: [CGFloat]
	var height: CGFloat
	var size: CGSize?
	var rendered: [TableItemUI]
}

final class TableUI {
	private var state: TableState { didSet { render() } }
	let io = TableIOController()

	var items: [TableItem] { return state.items }
	let node: SKCropNode

	init(items: [TableItem]) {
		state = TableState(items: items)
		node = SKCropNode()
	}

	required init?(coder aDecoder: NSCoder) { fatalError() }

	func layout(size: CGSize) {
		node.maskNode = SKShapeNode(rectOf: size)
		state.size = size
	}

	func highlightPrev() {
		state.highlightPrev()
	}

	func highlightNext() {
		state.highlightNext()
	}

	func select() {
		if let idx = state.highlighted { state.items[idx].select() }
	}
}

private extension TableUI {

	func render() {
		guard let size = state.size else { return }

		let idx = state.visibleIndices

	}
}

extension TableUI {

	func setItems(_ items: [TableItem]) {
		state = TableState(items: items)
	}

	func insertItem(_ item: TableItem, at idx: Int) {
		state.insertItem(item, at: idx)
	}

	func appendItem(_ item: TableItem) {
		insertItem(item, at: items.endIndex)
	}

	func removeItem(at idx: Int) {
		state.removeItem(at: idx)
	}

	func updateItem(_ item: TableItem, at idx: Int) {
		state.updateItem(item, at: idx)
	}
}

private extension TableState {

	init(items: [TableItem]) {
		self.items = items
		highlighted = items.isEmpty ? nil : 0
		offset = 0
		heights = items.map { $0.height() }
		height = heights.reduce(0, +)
		rendered = []
	}

	func offsetTo(_ idx: Int) -> CGFloat {
		return heights.prefix(upTo: idx).reduce(0, +)
	}

	var visibleIndices: [Int] {
		guard let boundsHeight = size?.height, !heights.isEmpty else { return [] }
		let visibleBounds = offset...(offset + boundsHeight)

		let itemsBounds = heights.dropLast().reduce(into: [0...heights.first!], {
			$0.append($0.last!.upperBound...($0.last!.upperBound + $1))
		})

		return itemsBounds.enumerated()
			.filter { idx, itemBounds in visibleBounds.overlaps(itemBounds) }
			.map { idx, _ in idx }
	}

	mutating func highlightPrev() {
		highlighted = highlighted.map { max($0 - 1, 0) }
	}

	mutating func highlightNext() {
		highlighted = highlighted.map { min($0 + 1, items.count - 1) }
	}

	mutating func insertItem(_ item: TableItem, at idx: Int) {
		items.insert(item, at: idx)
		let delta = item.height()
		heights.insert(delta, at: idx)
		highlighted = highlighted.map { idx < $0 ? $0 + 1 : $0 }
	}

	mutating func removeItem(at idx: Int) {
		items.remove(at: idx)
		let delta = heights.remove(at: idx)
		height -= delta
		highlighted = items.isEmpty ? nil : highlighted.map {
			min(max(idx < $0 ? $0 - 1 : $0, 0), items.count - 1)
		}
	}

	mutating func updateItem(_ item: TableItem, at idx: Int) {
		items[idx] = item
		let delta = item.height() - heights[idx]
		heights[idx] += delta
		height += delta
	}
}

final class TableIOController {

}
