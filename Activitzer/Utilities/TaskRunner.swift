import Foundation

func runTask(
  _ operation: @escaping @Sendable () async throws -> Void
) {
  Task {
    do {
      try await operation()
    } catch {
      handleError(error)
    }
  }
}

func runMainTask(
  _ operation: @escaping @MainActor @Sendable () async throws -> Void
) {
  Task {
    do {
      try await operation()
    } catch {
      handleError(error)
    }
  }
}
