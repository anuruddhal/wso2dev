import ballerina/http;
import ballerina/config;

public type BasicAuthConfig record {
    string username;
    string password;
    !...
};

public type OAuthConfig record {
    string accessToken;
    !...
};

public type MutualSSLConfig record {
    string keystorePath;
    string keystorePassword;
    !...
};

public type KubernetesConnectorConfiguration record {
    string masterURL;
    string namespace;
    BasicAuthConfig|OAuthConfig|MutualSSLConfig authConfig;
    string trustStorePath;
    string trustStorePassword;
    http:ClientEndpointConfig clientConfig;
};

public type Client object {
    public KubernetesConnectorConfiguration kubernetesConfig;
    public KubernetesConnector k8sconnector = new;

    public function init(KubernetesConnectorConfiguration config);
    public function getCallerActions() returns KubernetesConnector;
};

function Client::init(KubernetesConnectorConfiguration config) {
    self.k8sconnector.masterURL = config.masterURL;

    config.clientConfig.url = config.masterURL;

    if (config.namespace.length() <= 0) {
        config.namespace = "default";
    }

    self.k8sconnector.namespace = config.namespace;

    if (config.trustStorePassword.length() > 0 && config.trustStorePath.length() > 0){
        config.clientConfig.secureSocket = {
            trustStore: {
                path: config.trustStorePath,
                password: config.trustStorePassword
            }
        };
    }
    http:AuthConfig authConfig = {};
    match (config.authConfig){
        BasicAuthConfig basicAuthConfig => {
            authConfig =
            {
                scheme: http:BASIC_AUTH,
                username: basicAuthConfig.username,
                password: basicAuthConfig.password
            };
        }
        OAuthConfig oAuthConfig => {
            authConfig = {
                scheme: http:OAUTH2,
                accessToken: oAuthConfig.accessToken
            };

        }
        MutualSSLConfig mutualSSLConfig => {
            config.clientConfig.secureSocket = {
                trustStore: {
                    path: config.trustStorePath,
                    password: config.trustStorePassword
                },
                keyStore: {
                    path: mutualSSLConfig.keystorePath,
                    password: mutualSSLConfig.keystorePassword
                },
                protocol: { name: "TLS" },
                ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
            };
        }
    }
    config.clientConfig.auth = authConfig;
    self.k8sconnector.client.init(config.clientConfig);
}

function Client::getCallerActions() returns KubernetesConnector {
    return self.k8sconnector;
}