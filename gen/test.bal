import ballerina/io;

public type Deployment record {
    string name;
    string imageName;
};

public type Service record {
    string name;
};

public type MySvc record {
    string serviceName;
    Deployment deployment;
    Service? k8service;
};


public function main(string... args) {
    MySvc svc = {
        serviceName: "hello",
        deployment: {
            name: "ballerinax",
            imageName: "dev.io/ballerina:1.0"
        }
    };

    io:println(svc);
    svc.deployment.name = "ballerina2";
    io:println(svc);
}
