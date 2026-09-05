import Testing
@testable import Lithe

@Suite("Module capability store")
@MainActor
struct ModuleCapabilityStoreTests {
    @Test
    func cachesCapabilitiesByIDAndPreservesTypeSafety() {
        let store = ModuleCapabilityStore()
        let capability = TestCapability()

        store.cache(capability, id: .gitWorkspace, moduleID: .git)

        #expect(store.capability(.gitWorkspace) === capability)
        #expect(store.capability(.gitWorkspace, as: OtherCapability.self) == nil)
    }

    @Test
    func clearingAModuleRemovesOnlyItsCapabilities() {
        let store = ModuleCapabilityStore()
        let gitCapability = TestCapability()
        let searchCapability = OtherCapability()

        store.cache(gitCapability, id: .gitWorkspace, moduleID: .git)
        store.cache(searchCapability, id: .searchWorkspace, moduleID: .search)

        store.clear(for: .git)

        #expect(store.capability(.gitWorkspace, as: TestCapability.self) == nil)
        #expect(store.capability(.searchWorkspace) === searchCapability)
    }
}

private final class TestCapability {}
private final class OtherCapability {}
