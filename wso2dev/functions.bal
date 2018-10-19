// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
import ballerina/log;
import ballerina/io;
import ballerina/runtime;
import ballerina/math;
import wso2/kubernetes;
import ballerina/config;

public function getDeploymentJSON(Application appDefinition) returns (json) {
    string image;
    match appDefinition.source {
        DockerSource dockerSource => {
            image = dockerSource.tag;
        }
        ImageSource imageSource => {
            image = imageSource.dockerImage;
        }
        GitSource gitSource => {
            image = gitSource.tag;
        }
    }
    json deployment = {
        "apiVersion": "apps/v1",
        "kind": "Deployment",
        "metadata": {
            "name": <json>appDefinition.name,
            "labels": check <json>appDefinition.deployment.labels
        },
        "spec": {
            "replicas": <json>appDefinition.deployment.replicas,
            "selector": {
                "matchLabels": check <json>appDefinition.deployment.labels
            },
            "template": {
                "metadata": {
                    "labels": check <json>appDefinition.deployment.labels
                },
                "spec": {
                    "containers": [
                        {
                            "env": check <json>appDefinition.deployment.env,
                            "name": <json>appDefinition.name,
                            "image": image,
                            "ports": check <json>appDefinition.deployment.containerPorts
                        }
                    ]
                }
            }
        }
    };
    return deployment;
}

public function getServiceJSON(Application appDefinition) returns (json[]) {
    json[] servicesJSON = [];
    map<ServiceConfiguration> services = appDefinition.services;
    foreach serviceKey, serviceDef in services {
        json serviceJson = {
            "apiVersion": "v1",
            "kind": "Service",
            "metadata": {
                "annotations": check <json>serviceDef.annotations,
                "finalizers": [],
                "labels": check <json>serviceDef.labels,
                "name": <json>serviceKey,
                "ownerReferences": []
            },
            "spec": {
                "externalIPs": [],
                "loadBalancerSourceRanges": [],
                "ports": check <json>serviceDef.ports,
                "selector": check <json>serviceDef.selector,
                "type": serviceDef.serviceType
            }
        };
        servicesJSON[lengthof servicesJSON] = serviceJson;
    }
    return servicesJSON;

}

public function getIngressJSON(Application appDefinition) returns (json[]) {
    json[] ingressJSON = [];
    map<IngressConfiguration> ingresses = appDefinition.ingresses;
    foreach ingressKey, ingressDef in ingresses {
        json ingerssJSON = {
            "apiVersion": "extensions/v1beta1",
            "kind": "Ingress",
            "metadata": {
                "annotations": check <json>ingressDef.annotations,
                "finalizers": [],
                "labels": check <json>ingressDef.labels,
                "name": <json>ingressKey,
                "ownerReferences": []
            },
            "spec": check <json>ingressDef.spec
        };
        ingressJSON[lengthof ingressJSON] = ingerssJSON;
    }
    return ingressJSON;
}

endpoint kubernetes:Client k8sEndpoint {
    masterURL: config:getAsString("dockerForMac.masterURL"),
    authConfig: {
        keystorePath: config:getAsString("dockerForMac.sslkeyStorePath"),
        keystorePassword: config:getAsString("dockerForMac.sslkeyStorePassword")
    },
    namespace: "default",
    trustStorePath: config:getAsString("dockerForMac.trustStorePath"),
    trustStorePassword: config:getAsString("dockerForMac.trustStorePassword")
};

public function deploy(Application appDefinition) returns (json) {
    json deployment = getDeploymentJSON(appDefinition);
    json[] k8sServices = getServiceJSON(appDefinition);
    json[] ingressServices = getIngressJSON(appDefinition);
    log:printInfo("Deploying kubernetes artifacts");

    //Deploy services
    json[] serviceStatuses;
    foreach k8sService in k8sServices {
        serviceStatuses[lengthof serviceStatuses] = k8sEndpoint->createService(k8sService);
        log:printInfo("Service \"" + k8sService.metadata.name.toString() + "\" created.");
        writeJSON(k8sService, k8sService.metadata.name.toString() + ".json");
        vaildateResource(serviceStatuses[lengthof serviceStatuses - 1]);
    }

    //Deploy ingress
    json[] ingressStatuses;
    foreach ingressService in ingressServices {
        ingressStatuses[lengthof ingressStatuses] = k8sEndpoint->createIngress(ingressService);
        log:printInfo("Ingress \"" + ingressService.metadata.name.toString() + "\" created.");
        writeJSON(ingressService, ingressService.metadata.name.toString() + ".json");
        vaildateResource(ingressStatuses[lengthof ingressStatuses - 1]);
    }

    //Deploy deployment
    json deploymentStatus = k8sEndpoint->createDeployment(deployment);
    writeJSON(deployment, deployment.metadata.name.toString() + ".json");
    log:printInfo("Deployment \"" + deployment.metadata.name.toString() + "\" created.");
    vaildateResource(deploymentStatus);

    json result = {
        "deploymentStatus": deploymentStatus,
        "serivceStatus": serviceStatuses,
        "ingressStatus": ingressStatuses
    };
    return result;
}

public function undeploy(Application appDefinition) returns (json) {
    json deployment = getDeploymentJSON(appDefinition);
    json[] k8sServices = getServiceJSON(appDefinition);
    json[] ingressServices = getIngressJSON(appDefinition);
    log:printInfo("Deploying kubernetes artifacts");

    //Deploy services
    json[] serviceStatuses;
    foreach k8sService in k8sServices {
        serviceStatuses[lengthof serviceStatuses] = k8sEndpoint->deleteService(k8sService.metadata.name.toString());
        log:printInfo("Service \"" + k8sService.metadata.name.toString() + "\" deleted.");
    }

    //Deploy ingress
    json[] ingressStatuses;
    foreach ingressService in ingressServices {
        ingressStatuses[lengthof ingressStatuses] = k8sEndpoint->deleteIngress(ingressService.metadata.name.toString());
        log:printInfo("Ingress \"" + ingressService.metadata.name.toString() + "\" deleted.");
    }

    //Deploy deployment
    json deploymentStatus = k8sEndpoint->deleteDeployment(deployment.metadata.name.toString());
    log:printInfo("Deployment \"" + deployment.metadata.name.toString() + "\" deleted.");

    json result = {
        "deploymentStatus": deploymentStatus,
        "serivceStatus": serviceStatuses,
        "ingressStatus": ingressStatuses
    };
    return result;
}

public function vaildateResource(json status) {
    if ("Status" == <string>status.kind) {
        //Error while deploying artifacts.
        log:printError(status.toString());
    }
}

public function getDeployment(string deploymentName) returns (json) {
    json deployment = k8sEndpoint->getDeployment(deploymentName);
    return deployment;
}

function close(io:CharacterChannel characterChannel) {
    characterChannel.close() but {
        error e =>
        log:printError("Error occurred while closing character stream",
            err = e)
    };
}

function writeJSON(json content, string fileName) {
    string path = "./target/kubernetes/" + fileName;
    io:ByteChannel byteChannel = io:openFile(path, io:WRITE);

    io:CharacterChannel ch = new io:CharacterChannel(byteChannel, "UTF8");

    match ch.writeJson(content) {
        error err => {
            close(ch);
            throw err;
        }
        () => {
            close(ch);
            log:printDebug("Content written successfully");
        }
    }
}