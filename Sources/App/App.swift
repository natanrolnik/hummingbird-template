import Configuration
import Hummingbird
import Logging

{{^hbLambda}}
@main
struct App {
    static func main() async throws {
        let reader = ConfigReader(providers: [
            CommandLineArgumentsProvider(),
            EnvironmentVariablesProvider(),
            InMemoryProvider(values: [
                "server.name": "{{hbPackageName}}"
            ])
        ])
        let app = try await buildApplication(reader: reader)
        try await app.runService()
    }
}
{{/hbLambda}}
{{#hbLambda}}
@main
struct Lambda {
    static func main() async throws {
        let reader = ConfigReader(providers: [
            EnvironmentVariablesProvider()
        ])
        let lambda = try await buildLambda(reader: reader)
        try await lambda.runService()
    }
}
{{/hbLambda}}
