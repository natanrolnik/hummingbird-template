import Configuration
import Hummingbird
import Logging

{{^hbLambda}}
/// The main entry point of the application.
///
/// Configuration can be provided via command-line arguments or environment variables.
/// Command-line arguments take precedence over environment variables.
///
/// ## Supported configuration
///
/// - `--host` / `HTTP_HOST`: Hostname or IP to bind to (default: `127.0.0.1`)
/// - `--port` / `HTTP_PORT`: Port number to listen on (default: `8080`)
/// - `--log-level` / `LOG_LEVEL`: Logging level - See `Logger.Level` for the possible values (default: `info`)
///
/// ## Examples
///
/// Using command-line arguments:
/// ```bash
/// swift run {{hbExecutableName}} --host 0.0.0.0 --port 3000 --log-level debug
/// ```
///
/// Using environment variables:
/// ```bash
/// HTTP_HOST=0.0.0.0 HTTP_PORT=3000 LOG_LEVEL=debug swift run {{hbExecutableName}}
/// ```
@main
struct App {
    static func main() async throws {
        let configReader = ConfigReader(providers: [
            CommandLineArgumentsProvider(),
            EnvironmentVariablesProvider().prefixKeys(with: "http"),
            EnvironmentVariablesProvider()
        ])
        let app = try await buildApplication(configReader: configReader)
        try await app.runService()
    }
}
{{/hbLambda}}
{{#hbLambda}}
@main
struct Lambda {
    static func main() async throws {
        let lambda = try await buildLambda()
        try await lambda.runService()
    }
}
{{/hbLambda}}
