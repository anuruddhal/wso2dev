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
            dockerImage: "mysql:5.7"
        },
        containerPorts: [{ containerPort: 3306, protocol: "TCP" }],
        env: [{ name: "MYSQL_ROOT_PASSWORD", value: config:getAsString("mysql.password") }, { name: "MYSQL_DB", value:
        "test" }]
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
            dockerImage: "anuruddhal/helloworld:v1"
        },
        containerPorts: [{ containerPort: springBootAppPort, protocol: "TCP" }],
        env: [{ name: "MYSQL_HOST", value: mysqlHostname }]
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

public function main(string... args) {
    var v = wso2dev:deploy(mysqlApp);
    json dep = wso2dev:getDeployment(mysqlApp.name);
    while (dep.status.readyReplicas == null || check <int>dep.status.readyReplicas < 1) {
        io:println("waiting for mysql service ....");
        runtime:sleep(1000);
        dep = wso2dev:getDeployment(mysqlApp.name);
    }
    var v2 = wso2dev:deploy(springBootApp);
    io:println("exit....");
}
