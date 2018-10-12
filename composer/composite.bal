import developer;
import ballerina/io;
import wso2dev;

public function main(string... args) {
    developer:springBootApp.deployment.namespace = "wso2";
    developer:springBootApp.deployment.replicas = 3;
    developer:springBootApp.services["MyBallerinaAppSvc"].serviceType = "ClusterIP";
    developer:springBootApp.ingresses = {
        "MyAppIngress": {
            annotations: { "nginx.ingress.kubernetes.io/ssl-passthrough": "true",
                "kubernetes.io/ingress.class": "nginx"
            },
            rules: {
                "sample.com": { host: "sample.com", serviceName: "MyBallerinaAppSvc", servicePort: 9090, path: "/" }
            }
        }
    };
    io:println(wso2dev:deploy(developer:springBootApp));
}

