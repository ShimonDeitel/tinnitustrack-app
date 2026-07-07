import XCTest
@testable import Tinnitustrack

@MainActor
final class TinnitustrackTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
    }

    func testSeedDataIsBelowFreeLimit() {
        XCTAssertLessThan(store.entries.count, Store.freeLimit)
    }

    func testAddIncreasesCount() {
        let before = store.entries.count
        let added = store.add(Entry(date: Date(), rating: 4, note: "test", tags: ["A"]))
        XCTAssertTrue(added)
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testAddRespectsFreeLimit() {
        for _ in 0..<(Store.freeLimit + 5) {
            _ = store.add(Entry(date: Date(), rating: 4, note: "test", tags: ["A"]))
        }
        XCTAssertEqual(store.entries.count, Store.freeLimit)
    }

    func testIsAtLimitBecomesTrue() {
        for _ in 0..<Store.freeLimit {
            _ = store.add(Entry(date: Date(), rating: 4, note: "test", tags: ["A"]))
        }
        XCTAssertTrue(store.isAtLimit)
    }

    func testDeleteRemovesItem() {
        _ = store.add(Entry(date: Date(), rating: 4, note: "test", tags: ["A"]))
        let before = store.entries.count
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.entries.count, before - 1)
    }

    func testAddBeyondLimitReturnsFalse() {
        for _ in 0..<Store.freeLimit {
            _ = store.add(Entry(date: Date(), rating: 4, note: "test", tags: ["A"]))
        }
        let result = store.add(Entry(date: Date(), rating: 4, note: "test", tags: ["A"]))
        XCTAssertFalse(result)
    }

    func testDeleteSpecificItem() {
        let item = Entry(date: Date(), rating: 4, note: "test", tags: ["A"])
        _ = store.add(item)
        let before = store.entries.count
        store.delete(item)
        XCTAssertEqual(store.entries.count, before - 1)
    }
}
