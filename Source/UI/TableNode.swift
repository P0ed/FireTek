import SpriteKit
import Fx

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
	let node: SKNode

	init(items: [TableItem]) {
		state = TableState(items: items)
		node = SKNode()
	}

	required init?(coder aDecoder: NSCoder) { fatalError() }

	func layout(size: CGSize) {
		state.size = size
	}

	func highlightPrev() {
		guard let idx = state.highlighted, idx > 0 else { return }
		state.highlighted = idx - 1
	}

	func highlightNext() {
		guard let idx = state.highlighted, idx < items.count - 1 else { return }
		state.highlighted = idx + 1
	}

	func select() {
		guard let idx = state.highlighted else { return }
		items[idx].select()
	}

	private func render() {

	}
}

extension TableUI {

	func setItems(_ items: [TableItem]) {
		state = TableState(items: items)
	}

	func insertItem(_ item: TableItem, at idx: Int) {
		modify(&state) { state in
			state.items.insert(item, at: idx)
			let delta = item.height()
			state.heights.insert(delta, at: idx)
		}
	}

	func appendItem(_ item: TableItem) {
		insertItem(item, at: items.endIndex)
	}

	func removeItem(at idx: Int) {
		modify(&state) { state in
			state.items.remove(at: idx)
			let delta = state.heights.remove(at: idx)
			state.height -= delta
		}
	}

	func updateItem(_ item: TableItem, at idx: Int) {
		modify(&state) { state in

		}
	}
}

struct TableItem {
	let create: () -> TableItemUI
	let height: () -> CGFloat
	let select: VoidFunc
}

struct TableItemUI {
	let node: SKNode
	let layout: Sink<CGFloat>
	let setHighlighted: Sink<Bool>
}

final class TableIOController {

}

extension TableState {

	init(items: [TableItem]) {
		self.items = items
		highlighted = items.isEmpty ? nil : 0
		offset = 0
		heights = items.map { $0.height() }
		height = heights.reduce(0, +)
		rendered = []
	}
}
