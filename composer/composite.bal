import developer;
import ballerina/io;
import wso2dev;

public function main(string... args) {
    developer:ballerinaApp.services["MyBallerinaAppSvc"].serviceType = "ClusterIP";
    io:println(check wso2dev:deploy(developer:ballerinaApp));
}

