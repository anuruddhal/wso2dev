// Auto Generated code
import wso2dev;
import ballerina/io;
import wso2/kubernetes;


public type RabbitmqEnvValue record{
    string adminPassword;
    string adminUsername;
};

public type RabbitmqService object {

    public wso2dev:Deployment deployment = {
        name: "RabbitmqDeployment",
        image: "docker.io/rabbitmq:1.0",
        replicas: 1,
        ports: [5672, 5671],
        imagePullPolicy: "Always"
    };

    wso2dev:EnvVar envAdminPassword;
    wso2dev:EnvVar envAdminUsername;
    public new(RabbitmqEnvValue envValues) {
        envAdminPassword = { name: { name: "ENV_ADMIN_PASSWORD" }, value: { value: envValues.adminPassword } };
        envAdminUsername = { name: { name: "ENV_ADMIN_USERNAME" }, value: { value: envValues.adminUsername } };
    }

    public function deploy() returns (json|error) {
        kubernetes:Deployment myAppDeployment = new;
        myAppDeployment = myAppDeployment
        .setMetaData({
                name: self.deployment.name,
                labels: { "app": self.deployment.name }
            })
        .addContainer({
                name: self.deployment.name,
                image: self.deployment.image,
                env: { "ENV_ADMIN_PASSWORD": self.envAdminPassword, "ENV_ADMIN_USERNAME": self.adminUsername },
                ports: [{
                    name: "port1", containerPort: self.deployment.port[0], protocol: "TCP"
                }, { name: "port2", containerPort: self.deployment.port[1], protocol: "TCP" }]
            })
        .setReplicaCount(self.deployment.replicas)
        .addMatchLabels("app", self.deployment.name);
        // Add K8s objects to the holder
        kubernetes:K8SHolder holder = new;
        holder.addDeployment(myAppDeployment);

        // Deploy the k8s objects in the cluster
        return k8sEndpoint->apply(holder);
    }
};

public type MyAppEnvValue record{
    string envRabbitmqUrl;
    string envQuickbooksUrl;
};


public type MyAppService object {

    public wso2dev:Deployment deployment = {
        image: "docker.io/myapp:1.0",
        minReplicas: 1,
        maxReplicas: 1,
        imagePullPolicy: "Always"
    };

    wso2dev:EnvVar envRabbitmqUrl;
    wso2dev:EnvVar envQuickbooksUrl;
    public new(MyAppEnvValue envValues) {
        envRabbitmqUrl = { name: { name: "ENV_RABBITMQ_URL" }, value: { value: envValues.envRabbitmqUrl } };
        envQuickbooksUrl = { name: { name: "ENV_QUICKBOOKS_URL" }, value: { value: envValues.envQuickbooksUrl } };
    }

    public function deploy() returns (json|error) {
        // Implementation goes here
    }
};