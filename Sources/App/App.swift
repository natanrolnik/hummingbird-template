import Configuration
import Hummingbird
import Logging

{{^hbLambda}}
@main
struct App {
    static func main() async throws {
        // Application will read configuration from the following in the order listed
        // Command line, Environment variables, dotEnv file, defaults provided in memory 
        let reader = try await ConfigReader(providers: [
            CommandLineArgumentsProvider(),
            EnvironmentVariablesProvider(),
            EnvironmentVariablesProvider(environmentFilePath: ".env", allowMissing: true),
            InMemoryProvider(values: [
                "http.serverName": "{{hbPackageName}}"
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
