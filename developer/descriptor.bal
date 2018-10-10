import wso2dev;
import ballerina/io;

public wso2dev:Application ballerinaApp = {
    name: "MyBallerinaApp",
    deployment: {
        namespace: "default",
        labels: { "language": "Ballerina", "app": "ballerinaApp" },
        replicas: 1,
        imagePullPolicy: "IfNotPresent",
        image: "myapp:1.0",
        env: { "RABBIT_MQ_URL": "https://localhost:5672" }
    },
    services: { "MyBallerinaAppSvc": {
        serviceType: "NodePort",
        ports: [{
            name: "http",
            port: 9090,
            targetPort: 9090,
            nodePort: 32100,
            protocol: "TCP"
        }] }
    },
    ingresses: {
        "MyAppIngress": {
            annotations: { "nginx.ingress.kubernetes.io/ssl-passthrough": "true",
                "kubernetes.io/ingress.class": "nginx"
            },
            rules: {
                "sample.com": { host: "sample.com", serviceName: "MyBallerinaAppSvc", servicePort: 9090, path: "/" }
            }
        }
    }
};

public function main(string... args) {
    io:println(check wso2dev:deploy(ballerinaApp));
}
