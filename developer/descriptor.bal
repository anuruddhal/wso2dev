import wso2dev;
import ballerina/io;
import ballerina/config;
import ballerina/runtime;

//@composite:Docker {}

@final public string mysqlHostname = "mysql-jdbc.com";
@final public int springBootAppPort = 8080;

public wso2dev:Application mysqlApp = {
    name: "mysql",
    deployment: {
        namespace: "default",
        labels: { "app": "mysql" },
        replicas: 1,
        imagePullPolicy: "IfNotPresent",
        source: {
            dockerImage: "mysql:5.7.0"
        },
        containerPorts: [{ port: 3306, protocol: "TCP" }],
        env: { "MYSQL_ROOT_PASSWORD": config:getAsString("mysql.password") }
    },
    services: { "mysql-svc": {
        name: mysqlHostname,
        serviceType: "ClusterIP",
        ports: [{
            name: "jdbc-port",
            port: 3306,
            targetPort: 3306,
            protocol: "TCP"
        }] }
    }
};


public wso2dev:Application springBootApp = {
    name: "sprintbootapp",
    deployment: {
        namespace: "default",
        labels: { "language": "Java", "app": "spring-boot-app" },
        replicas: 1,
        imagePullPolicy: "IfNotPresent",
        source: {
            dockerImage: "my-springboot-app:v1.0"
        },
        containerPorts: [{ containerPort: springBootAppPort, protocol: "TCP" }],
        env: { "MYSQL_HOST": mysqlHostname }
    },
    services: { "myspringappsvc": {
        serviceType: "NodePort",
        selector: { "app": "spring-boot-app" },
        ports: [{
            name: "http",
            port: springBootAppPort,
            targetPort: springBootAppPort,
            nodePort: 32100,
            protocol: "TCP"
        }] }
    }
};

//public function main(string... args) {
//
//    // Deploy mysql app
//    if (<string>wso2dev:deploy(mysqlApp).status == "success") {
//        io:println("Mysql deployed .....");
//        //Wait mysql app to be ready
//        while (<string>wso2dev:getDeployment(mysqlApp.name).status != "ready") {
//            io:println("waiting for mysql deployment to be ready .....");
//            runtime:sleep(1000);
//        }
//        io:println(wso2dev:deploy(springBootApp));
//        io:println("My Spring Boot App deployed !!");
//    }
//}

public function main(string... args) {
    io:println(wso2dev:deploy(springBootApp));
}
