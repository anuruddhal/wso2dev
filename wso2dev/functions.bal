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
import ballerina/io;
import ballerina/runtime;
import ballerina/math;
import kubernetes;
import ballerina/config;

public function getDeploymentJSON(Application appDefinition) returns (json) {
    string image;
    match appDefinition.deployment.source {
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
    io:println(deployment);
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
    json[] serviceStatuses;

    foreach k8sService in k8sServices {
        serviceStatuses[lengthof serviceStatuses] = k8sEndpoint->createService(k8sService);
    }
    json deploymentStatus = k8sEndpoint->createDeployment(deployment);

    json result = {
        "deploymentStatus": deploymentStatus,
        "serivceStatus": serviceStatuses
    };
    return result;
}

public function getDeployment(string deploymentName) returns (json) {
    json deployment = k8sEndpoint->getDeployment(deploymentName);
    return deployment;
}
