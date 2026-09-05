import Combine
import Foundation
import LitheModuleAPI

/// Owns the application-scoped bindings between module capability IDs and
/// their active capability instances.
///
/// The store deliberately knows nothing about a capability's feature type or
/// teardown behavior. AppModel remains responsible for product-specific
/// cleanup that must happen when a module is released.
@MainActor
final class ModuleCapabilityStore {
    private struct CachedCapability {
        let moduleID: ModuleID
        let value: AnyObject
    }

    private var capabilities: [ModuleCapabilityID: CachedCapability] = [:]
    private var featureObservations: [ModuleID: [AnyCancellable]] = [:]

    func capability<Capability: AnyObject>(
        _ id: ModuleCapabilityID,
        as type: Capability.Type = Capability.self
    ) -> Capability? {
        capabilities[id]?.value as? Capability
    }

    func cache(
        _ capability: AnyObject,
        id: ModuleCapabilityID,
        moduleID: ModuleID
    ) {
        capabilities[id] = CachedCapability(moduleID: moduleID, value: capability)
    }

    func observe(
        _ moduleID: ModuleID,
        observation: AnyCancellable
    ) {
        featureObservations[moduleID, default: []].append(observation)
    }

    func clear(for moduleID: ModuleID) {
        featureObservations[moduleID] = nil
        capabilities = capabilities.filter { $0.value.moduleID != moduleID }
    }
}
