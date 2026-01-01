{{#hbLambda}}
import AWSLambdaEvents
{{/hbLambda}}
import Configuration
import Hummingbird
{{#hbLambda}}
import HummingbirdLambda
{{/hbLambda}}
import Logging
{{#hbOpenAPI}}
import OpenAPIHummingbird
{{/hbOpenAPI}}

// Request context used by {{^hbLambda}}application{{/hbLambda}}{{#hbLambda}}lambda<{{hbLambdaType}}Request>{{/hbLambda}}
typealias AppRequestContext = {{^hbLambda}}BasicRequestContext{{/hbLambda}}{{#hbLambda}}BasicLambdaRequestContext<{{hbLambdaType}}Request>{{/hbLambda}}

{{^hbLambda}}
///  Build application
/// - Parameter reader: configuration reader
func buildApplication(reader: ConfigReader) async throws -> some ApplicationProtocol {
{{/hbLambda}}
{{#hbLambda}}
///  Build AWS Lambda function
/// - Parameter reader: configuration reader
func buildLambda(reader: ConfigReader) async throws -> {{hbLambdaType}}LambdaFunction<RouterResponder<AppRequestContext>> {
{{/hbLambda}}
    let logger = {
        var logger = Logger(label: "{{hbPackageName}}")
        logger.logLevel = reader.string(forKey: "log.level", as: Logger.Level.self, default: .info)
        return logger
    }()
    let router = try buildRouter()
{{^hbLambda}}
    let app = Application(
        router: router,
        configuration: ApplicationConfiguration(reader: reader.scoped(to: "http")),
        logger: logger
    )
    return app
{{/hbLambda}}
{{#hbLambda}}
    let lambda = {{hbLambdaType}}LambdaFunction(
        router: router,
        logger: logger
    )
    return lambda
{{/hbLambda}}
}

/// Build router
func buildRouter() throws -> Router<AppRequestContext> {
    let router = Router(context: AppRequestContext.self)
    // Add middleware
    router.addMiddleware {
        // logging middleware
        LogRequestsMiddleware(.info)
{{#hbOpenAPI}}
        // store request context in TaskLocal
        OpenAPIRequestContextMiddleware()
{{/hbOpenAPI}}
    }
{{#hbOpenAPI}}
    // Add OpenAPI handlers
    let api = APIImplementation()
    try api.registerHandlers(on: router)
{{/hbOpenAPI}}
{{^hbOpenAPI}}
    // Add default endpoint
    router.get("/") { _,_ in
        return "Hello!"
    }
{{/hbOpenAPI}}
    return router
}
