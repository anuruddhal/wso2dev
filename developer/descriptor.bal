import wso2dev;

@wso2dev:Docker{
    ENV_ADMIN_PASSWORD: "admin",
    ENV_ADMIN_USERNAME: "admin"
}
wso2dev:DockerImage rabbitmqImage = {
    name: "dev.io/rabbitmq:1.0.0",
    ports: [5672, 5671],
    envVariables: [{ name: "ENV_ADMIN_PASSWORD", name:"ENV_ADMIN_USERNAME" }]
};

//@wso2dev:Gen {}
wso2dev:EgressAPI salesForeceAPI = {
    name: "sales-force",
    protocol: "https",
    port: 443,
    host: "salesforce.com"
};

//@wso2dev:Gen {}
wso2dev:EgressAPI quickBookAPI = {
    name: "quick-books",
    protocol: "https",
    port: 443,
    host: "quickbooks.com"
};

//@wso2dev:Gen {}
wso2dev:EnvVarName envRabbitmqUrl = { name: "ENV_RABBITMQ_URL" };

//@wso2dev:Gen {}
wso2dev:EnvVarName quickBooksURL = { name: "ENV_QUICKBOOKS_URL" };


