import ballerina/io;
import gen;
import wso2dev;
import ballerina/config;


public function main(string... args) {

    gen:RabbitmqEnvValue rabbitmqEnvValue = {
        adminPassword: config:getAsString("adminPassword"),
        adminUsername: config:getAsString("adminUsername")
    };
    gen:RabbitmqService rabbitmqSvc = new(rabbitmqEnvValue);
    rabbitmqSvc.deployment.maxReplicas = 2;
    rabbitmqSvc.deployment.min = 2;
    rabbitmqSvc.deployment.image = "kk";

    rabbitmqSvc.security.maxReplicas = 2;

    if (rabbitmqSvc.deploy().status == "true") {
        gen:MyAppEnvValue myappEnvValue = {
            envRabbitmqUrl: config:getAsString("rabbitmqUrl"),
            envQuickbooksUrl: config:getAsString("quickbooksUrl")
        };
        gen:MyAppService myAppSvc = new(myappEnvValue);
        myAppSvc.deploy();
    }
}

