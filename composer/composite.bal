//import developer;
//import ballerina/io;
//import wso2dev;
//
//public function main(string... args) {
//    developer:springBootApp.deployment.namespace = "wso2";
//    developer:springBootApp.deployment.replicas = 3;
//    developer:springBootApp.services["myspringappsvc"].serviceType = "ClusterIP";
//    developer:springBootApp.services["myspringappsvc"].ports = [{
//        name: "http",
//        port: developer:springBootAppPort,
//        targetPort: developer:springBootAppPort,
//        protocol: "TCP"
//    }];
//    developer:springBootApp.ingresses = {
//        "spring-app": {
//            annotations: {
//                "nginx.ingress.kubernetes.io/ssl-passthrough": "true",
//                "kubernetes.io/ingress.class": "nginx"
//            },
//            spec: {
//                rules: [{
//                    host: "myapp.com",
//                    http: {
//                        paths: [{
//                            backend: {
//                                serviceName: "myspringappsvc",
//                                servicePort: developer:springBootAppPort
//                            },
//                            path: "/"
//                        }
//                        ]
//                    }
//                }]
//            }
//        }
//    };
//    io:println(wso2dev:deploy(developer:springBootApp));
//}
//
