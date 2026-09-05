import Foundation
import LitheCoreContracts
import LitheWorkspaceModule

/// Constructs the per-session feature models used by AppModel.
///
/// This graph only owns construction. Runtime activation, observations, and
/// workspace lifecycle remain in AppModel until their dedicated migrations are
/// complete.
@MainActor
final class AppModelFeatureGraph {
    let keyboardShortcut: KeyboardShortcutFeatureModel
    let notification: WorkbenchNotificationFeatureModel
    let workbenchBackground: WorkbenchBackgroundFeatureModel
    let runtime: RuntimeSettingsFeatureModel
    let languageTooling: LanguageToolingFeatureModel
    let workspace: WorkspaceFeatureModel
    let github: GitHubFeatureModel
    let discourseCommunity: DiscourseCommunityFeatureModel
    let editorTabOrder: EditorTabOrderFeatureModel
    let media: MediaDocumentFeatureModel
    let terminalPlacement: TerminalPlacementFeatureModel
    let document: DocumentFeatureModel
    let navigationHistory: NavigationHistoryFeatureModel
    let java: JavaFeatureModel
    let spring: SpringFeatureModel

    init(settings: AppSettings, services: AppServices) {
        keyboardShortcut = KeyboardShortcutFeatureModel(settings: settings)
        notification = WorkbenchNotificationFeatureModel()
        workbenchBackground = WorkbenchBackgroundFeatureModel(
            settings: settings,
            platform: services.workbenchBackgroundPlatform
        )
        runtime = RuntimeSettingsFeatureModel(service: services.projectRuntimeService)
        languageTooling = LanguageToolingFeatureModel(
            catalogSource: services.languageProviderCatalogSource,
            catalogSnapshot: services.languageProviderCatalogSnapshot,
            sessionsProvider: { nil }
        )
        workspace = WorkspaceFeatureModel(
            operations: services.workspaceOperations,
            fileOperations: services.fileOperations,
            gitWatchContextProvider: services.gitWatchContextProvider,
            directoryWatcherFactory: services.directoryWatcherFactory,
            workspaceSessionStore: services.workspaceSessionStore,
            directoryMarkStore: services.directoryMarkStore
        )
        github = GitHubFeatureModel(service: services.githubService)
        discourseCommunity = DiscourseCommunityFeatureModel(
            service: services.discourseCommunityService
        )
        editorTabOrder = EditorTabOrderFeatureModel()
        media = MediaDocumentFeatureModel()
        terminalPlacement = TerminalPlacementFeatureModel()
        document = DocumentFeatureModel(
            operations: services.workspaceOperations,
            documentLifecycleDecider: services.documentLifecycleDecider,
            fileOperations: services.fileOperations,
            fileStorage: services.fileStorage,
            binaryFileViewerRegistry: services.binaryFileViewerRegistry
        )
        navigationHistory = NavigationHistoryFeatureModel()
        java = JavaFeatureModel(operations: services.javaMavenOperations)
        spring = SpringFeatureModel(operations: services.javaMavenOperations)
    }
}
