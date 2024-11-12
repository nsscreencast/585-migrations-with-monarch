import Foundation

protocol FileProvider {
    func load(_ file: URL) throws -> Data?
    func write(data: Data, to file: URL) throws

    var documentsDirectory: URL { get }
}

extension FileManager: FileProvider {
    func load(_ file: URL) throws -> Data? {
        guard fileExists(atPath: file.path()) else { return nil }

        return try Data(contentsOf: file)
    }

    func write(data: Data, to file: URL) throws {
        try data.write(to: file)
    }

    var documentsDirectory: URL {
        urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}

class InMemoryFileProvider: FileProvider {
    var documentsDirectory: URL {
        URL(filePath: "/tmp")
    }

    var storage: [URL: Data] = [:]

    func load(_ file: URL) throws -> Data? {
        storage[file]
    }

    func write(data: Data, to file: URL) throws {
        storage[file] = data
    }
}

