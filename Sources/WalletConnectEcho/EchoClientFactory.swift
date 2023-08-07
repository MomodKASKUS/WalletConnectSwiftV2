import Foundation

public struct EchoClientFactory {
    public static func create(projectId: String,
                              echoHost: String,
                              environment: APNSEnvironment) -> EchoClient {

        let keychainStorage = KeychainStorage(serviceIdentifier: "com.walletconnect.sdk")

        return EchoClientFactory.create(
            projectId: projectId,
            echoHost: echoHost,
            keychainStorage: keychainStorage,
            environment: environment)
    }

    public static func create(
        projectId: String,
        echoHost: String,
        keychainStorage: KeychainStorageProtocol,
        environment: APNSEnvironment
    ) -> EchoClient {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 1.0
        sessionConfiguration.timeoutIntervalForResource = 1.0
        let session = URLSession(configuration: sessionConfiguration)

        let httpClient = HTTPNetworkClient(host: echoHost, session: session)

        let clientIdStorage = ClientIdStorage(keychain: keychainStorage)

        let echoAuthenticator = EchoAuthenticator(clientIdStorage: clientIdStorage, echoHost: echoHost)

        let logger = ConsoleLogger(loggingLevel: .debug)

        let registerService = EchoRegisterService(httpClient: httpClient, projectId: projectId, clientIdStorage: clientIdStorage, echoAuthenticator: echoAuthenticator, logger: logger, environment: environment)

        return EchoClient(
            registerService: registerService)
    }
}
