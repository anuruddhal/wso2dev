//public wso2dev:Application mySpringBootApp = {
//    name: "MySpringBootApp",
//    projectVersion: "1.0.0",
//    projectType: "springboot:2.3.4",
//    ports: [8080],
//    deployment: {
//        namespace: "default",
//        labels: { "language": "java", "app": "MySpringBootApp" },
//        replicas: 1,
//        imagePullPolicy: "IfNotPresent",
//        source: {
//            dockerImage: "myspringbootapp:1.0.0"
//        },
//        containerPorts: [{ port: 8080, protocol: "TCP" }]
//    },
//    services: { "MySpringBootAppSvc": {
//        serviceType: "NodePort",
//        ports: [{
//            name: "http",
//            port: 8080,
//            targetPort: 8080,
//            nodePort: 32100,
//            protocol: "TCP"
//        }] }
//    }
//};
//
//public function main(string... args) {
//    io:println(wso2dev:deploy(ballerinaApp));
//}
