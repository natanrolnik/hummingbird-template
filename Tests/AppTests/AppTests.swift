import Configuration
import Hummingbird
{{^hbLambda}}
import HummingbirdTesting
{{/hbLambda}}
{{#hbLambda}}
import HummingbirdLambdaTesting
{{/hbLambda}}
import Logging
import XCTest

@testable import {{hbExecutableName}}

final class AppTests: XCTestCase {
{{^hbLambda}}
    func testApp() async throws {
        let reader = ConfigReader(providers: [
            InMemoryProvider(name: nil, values: [
                "host": "127.0.0.1",
                "port": "0",
                "log.level": "trace"
            ])
        ])
        let app = try await buildApplication(reader: reader)
        try await app.test(.router) { client in
            try await client.execute(uri: "/", method: .get) { response in
                XCTAssertEqual(response.body, ByteBuffer(string: "Hello!"))
            }
        }
    }
{{/hbLambda}}
{{#hbLambda}}
    func testLambda() async throws {
        let reader = ConfigReader(providers: [
            InMemoryProvider([
                "log.level": "trace"
            ])
        ])
        let lambda = try await buildLambda(reader: reader)
        try await lambda.test() { client in
            try await client.execute(uri: "/", method: .get) { response in
                XCTAssertEqual(response.body, "Hello!")
            }
        }
    }
{{/hbLambda}}
}
